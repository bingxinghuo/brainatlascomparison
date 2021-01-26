%% extract all subregion IDs from the hierarchy
function CC=allchildren(animalist,regionid)
CC=[];
for i=1:length(regionid)
    C=childreninfo(animalist,regionid(i),0);
    C=cell2mat(C(:,4));
    CC=[CC;C];
end