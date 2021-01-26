function [treenodes,regionids]=treeplotgen(regionlist)
% remove repeats
regionids=cell2mat(regionlist(:,4));
[~,ia]=unique(regionids);
regionlist=regionlist(ia,:);
%%
regionids=cell2mat(regionlist(:,4));
parentids=cell2mat(regionlist(:,6));
% regionids should be inclusive of parentids
uparentids=unique(parentids);
idcheck=ismember(uparentids,unique(regionids));
if sum(idcheck==0)>0
     % add the missing parent
    regionids=[uparentids(idcheck==0);regionids];
    parentids=[uparentids(idcheck==0);parentids];
end
Nregions=size(regionids,1);
treenodes=zeros(1,Nregions);
for n=1:Nregions
    treenodes(n)=find(regionids==parentids(n)); % each entry correspond to its parent
end
% [treenodes,sorti]=sort(treenodes);
% regionids=regionids(sorti); 
% treenodes(treenodes==1005)=0;
% figure, treeplot([0,treenodes]) % add a top level parent