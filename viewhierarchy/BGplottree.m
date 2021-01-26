function BGplottree(animallist,regionid,f)
% load('mouseregionlist')
% regionid=549;
CC=[];
for i=1:length(regionid)
    C=treeposition(animallist,regionid(i),0);
    CC=[CC;C];
end
[treenodes,regionids]=treeplotgen(CC);
regioninfo=[];
for i=1:length(regionid)
    regioninfo=[regioninfo;childreninfo(animallist,regionid(i),0,0)];
end
for i=1:length(regionids)
    regionlist(i,:)=childreninfo(animallist,regionids(i),0,0);
end
[BGdata,regionlist]=connmatgen(treenodes,regionlist);
BGobj=biograph(BGdata,regionlist(:,2));
for i=1:length(regionid)
    g=getnodesbyid(BGobj,regioninfo{i,2});
    set(g,'Color',[1 .7 .7]);
end
set(BGobj,'ShowArrows','off')
if nargin<3
    f=figure;
end
g=biograph.bggui(BGobj);
copyobj(g.biograph.hgAxes,f)