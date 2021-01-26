function regionid=findregionid(animallist,acronym,isfull)
if nargin<3
    isfull=0;
end
if isfull==0
    namelist=animallist(:,2);
    ind=find(strcmp(namelist,acronym));
else
    namelist=animallist(:,3); % full name
    ind=find(contains(namelist,acronym,'IgnoreCase',true));
end
if isempty(ind)
    regionid=0;
    disp('No matching name!')
elseif length(ind)==1
    regionid=animallist{ind,4};
else
    region_candidates=animallist(ind,:);
    region_candidates_table=cell2table([num2cell([1:length(ind)]'),region_candidates(:,2:3)],'VariableNames',{'Index','Acronym','Fullname'});
    disp(['Target region: ',acronym])
    disp(region_candidates_table)
    indi=input('Please select the desired region number: ');
    regionid=animallist{ind(indi),4};
end