%% getregioninfo.m
% extract the region information from the region list
function regioninfo=getregioninfo(animallist,idlist)
regionids=cell2mat(animallist(:,4));
ind=zeros(length(idlist),1);
for i=1:length(idlist)
    idind=find(regionids==idlist(i));
    if isempty(idind)
        disp([num2str(idlist(i)),' is not a valid region ID. Skip.']);
    elseif length(idind)>1
        disp('Potential error with the region list. Please double check. Abort.');
        return;
    else
        ind(i)=idind;
    end    
end
regioninfo=animallist(ind,:);