%%
% sample: aiainfo=lineageinfo(mouselist,1101);
function parentfullinfo=lineageinfo(animallist,regionid,ifdisp)
idlist=cell2mat(animallist(:,4));
idind=find(idlist==regionid);
regioninfo=animallist(idind,:);
regionlayer=animallist{idind,1};
parentfullinfo=regioninfo;
if ifdisp>0
    disp(['Layer ',num2str(regionlayer),' region (ID=',num2str(regionid),'): ',regioninfo{3}])
end
for L=1:regionlayer-1
    parentid=regioninfo{6};
    parentind=find(idlist==parentid);
    regioninfo=animallist(parentind,:);
    parentlayer=regioninfo{1};
    if ifdisp>0
        disp(['Layer ',num2str(parentlayer),' parent: (ID=',num2str(parentid),'): ',regioninfo{3}])
    end
    parentfullinfo=[regioninfo;parentfullinfo];
end