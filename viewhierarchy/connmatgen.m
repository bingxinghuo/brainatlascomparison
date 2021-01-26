%% treelist is the original list of regions that conndata was calculated from
function [BGdata,regionlist]=connmatgen(conndata,regionlist)
M=size(conndata,2);
[R,c]=size(regionlist);
regionids=cell2mat(regionlist(:,4));
parentids=cell2mat(regionlist(:,6));
if M>R % parents added in treeplotgen
    regionlist=[cell(M-R,c);regionlist];
    k=0;
    for r=1:R
        if ~ismember(parentids(r),regionids)
            k=k+1;
            regionlist(k,4)=num2cell(parentids(r));
            regionlist{k,2}=['Region',num2str(parentids(r))];
        end
    end
end
BGdata=zeros(M);
for i=1:M
    if conndata(i)>0
        BGdata(i,conndata(i))=1;
    end
end
BGdata=BGdata(1:M,1:M);
