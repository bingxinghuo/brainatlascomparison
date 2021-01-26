function match_hierarchy_view(species,L)
global LUT mouselist marmosetlist
% load('mouseregionlist');
% load('marmosetregionlist');
specieslist={'mouse';'marmoset'};
speciesi=ismember(specieslist,species);
species1=specieslist{~speciesi};
if strcmpi(species,'mouse')
    primarylist=mouselist;
    primaryLUT=LUT.mouse;
    searchlist=marmosetlist;
    searchLUT=LUT.marmoset;
elseif strcmpi(species,'marmoset')
    primarylist=marmosetlist;
    primaryLUT=LUT.marmoset;
    searchlist=mouselist;
    searchLUT=LUT.mouse;
end
primaryid=cell2mat(primaryLUT(L,1)');
BGplottree(primarylist,primaryid);
title(species)
f1=gcf;
set(f1,'Name',[species,' hierarchy'])
searchid=cell2mat(searchLUT(L,1)');
BGplottree(searchlist,searchid);
title(species1)
f2=gcf;
set(f2,'Name',[species1,' hierarchy'])
% close biograph viewers
child_handles = allchild(0);
names = get(child_handles,'Name');
k = find(strncmp('Biograph Viewer', names, 15));
close(child_handles(k))
% iptwindowalign(f1,'right',f2,'left')
% iptwindowalign(f1,'bottom',f2,'bottom')