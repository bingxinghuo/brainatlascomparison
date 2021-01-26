%% get the full pedigree/branching information of 1 tree node
function regiontree=treeposition(animallist,regionid,ifdisp)
parentfullinfo=lineageinfo(animallist,regionid,0);
childfullinfo=childreninfo(animallist,regionid,0);
regiontree=[parentfullinfo(1:end-1,:);childfullinfo];
if ifdisp>0
    dispheaders={'Position','Layer', 'RegionID', 'Fullname'};
    parentcell=[repmat({'Parent'},size(parentfullinfo,1)-1,1),parentfullinfo(1:end-1,[1,4,3])];
    regioncell=[{'Region'},parentfullinfo(end,[1,4,3])];
    childcell=[repmat({'Child'},size(childfullinfo,1)-1,1),childfullinfo(2:end,[1,4,3])];
    treetable=cell2table([parentcell;regioncell;childcell],'VariableNames',dispheaders);
    disp(treetable)
end
