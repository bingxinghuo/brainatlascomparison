%% extract all children based on one top node, given by region id.
function childfullinfo=childreninfo(animallist,id,ifdisp,levelsdown)
% identify children
regionids=cell2mat(animallist(:,4));
k=0;
ind=[find(regionids==id),k];
regioninfo=animallist(ind(1),:);
childfullinfo=regioninfo;
if ifdisp>0
    disp(['Layer ',num2str(regioninfo{1}),' region: (ID=',num2str(id),'): ',regioninfo{3}])
end
% regioninfo=animallist(ind,:);
parentids=cell2mat(animallist(:,6));
chind=find(parentids==id); % first layer down
if nargin<4 % if not specified, get all layers
    while ~isempty(chind) % descend
        regioninfo=animallist(chind,:);
        childfullinfo=[childfullinfo;regioninfo];
        if ifdisp>0
            disp(['Layer ',num2str(regioninfo{1,1}),' child(ren): '])
            disp([regioninfo(:,4),regioninfo(:,3)])
        end
        % regioninfo=[regioninfo;animallist(chind,:)];
        k=k-1;
        ind=[ind;chind,k*ones(length(chind),1)];
        gchind=[];
        for c=1:length(chind)
            id=regionids(chind(c));
            gchind=[gchind;find(parentids==id)];
        end
        chind=gchind;
        
    end
else
    if ~isempty(chind)
        if levelsdown>0
            for i=1:levelsdown
                regioninfo=animallist(chind,:);
                childfullinfo=[childfullinfo;regioninfo];
                if ifdisp>0
                    disp(['Layer ',num2str(regioninfo{1,1}),' child(ren): '])
                    disp([regioninfo(:,4),regioninfo(:,3)])
                end
                % regioninfo=[regioninfo;animallist(chind,:)];
                k=k-1;
                ind=[ind;chind,k*ones(length(chind),1)];
                gchind=[];
                for c=1:length(chind)
                    id=regionids(chind(c));
                    gchind=[gchind;find(parentids==id)];
                end
                chind=gchind;
            end
        end
    end
end


