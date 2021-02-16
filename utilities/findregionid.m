%% findregionid
function region1=findregionid(animallist,region,isfull)
% identify if the region is ID or name
if isnumeric(region)
    region1=region;
else
    region1=str2num(region);
end
if isempty(region1)
    if ~isempty(region) % name
        if nargin<3
            region1=findregionid_byname(animallist,region); % check for acronym
            if region1==0
                region1=findregionid_byname(animallist,region,1);   % check for full name
            end
        else
            region1=findregionid_byname(animallist,region,isfull);
        end
    else
        region1=0;
    end
end
end

function regionid=findregionid_byname(animallist,acronym,isfull)
if nargin<3
    isfull=0;
end
acronymlist=animallist(:,2);
if isfull==0
    ind=find(strcmp(acronymlist,acronym));
else
    ind=find(contains(acronymlist,acronym,'IgnoreCase',true));
    fullnamelist=animallist(:,3); % full name
    ind=[ind;find(contains(fullnamelist,acronym,'IgnoreCase',true))];
end
if isempty(ind)
    regionid=0;
    if isfull==0
    disp('No matching acronym!')
    else
        disp('No matching name!')
    end
elseif length(ind)==1
    %     regioncheck=input(['Accept the exact match of ',animallist{ind,2},' for "',acronym,'"?(y/n): '],'s');
    disp(['Found exact match of ',strjoin(animallist(ind,2:3),', '),' for "',acronym,'".']);
    regioncheck='y';
    if strcmpi(regioncheck,'y')
        regionid=animallist{ind,4};
    end
else
    region_candidates=animallist(ind,:);
    region_candidates_table=cell2table([num2cell([1:length(ind)]'),region_candidates(:,2:4)],'VariableNames',{'Index','Acronym','Fullname','AtlasID'});
    disp(['Target region: ',acronym])
    disp(region_candidates_table)
    indi=input('Please select the desired region number: ');
    if ~isempty(indi) && indi>0
        regionid=animallist{ind(indi),4};
    else
        regionid=0;
    end
end
end