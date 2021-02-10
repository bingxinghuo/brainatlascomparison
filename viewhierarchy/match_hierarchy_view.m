%% match_hierarchy_view.m
% Bingxing Huo, Jan 2021
% This script displays the region of interest in mouse and marmoset in the
% atlas hierarchy
% input:
%   - species: either "mouse" or "marmoset"
%   - L: location of the matched regions in LUT
% output:
%   Two windows should show up, one of hierarchical view of the primary brain region, and a second one for the corresponding region, if available.
% global variables:
%   - LUT: structure of lookup table across mouse and marmoset. Output from
%   LUTassemble.m
function match_hierarchy_view(species,L)
global LUT mouselist marmosetlist specieslist
%% 1. identify species-specific data
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
%% 2. primary tree
primaryid=cell2mat(primaryLUT(L,1)');
BGplottree(primarylist,primaryid); % display the hierarchical tree
title(species)
f1=gcf;
set(f1,'Name',[species,' hierarchy'])
%% 3. corresponding tree
searchid=cell2mat(searchLUT(L,1)');
if ~isempty(searchid)
    BGplottree(searchlist,searchid);  % display the hierarchical tree
    title(species1)
    f2=gcf;
    set(f2,'Name',[species1,' hierarchy'])
else
    disp(['No homologous region in ',species1,'. Skip hierarchy plot.'])
end
%% close biograph viewers
child_handles = allchild(0);
names = get(child_handles,'Name');
k = find(strncmp('Biograph Viewer', names, 15));
close(child_handles(k))
% iptwindowalign(f1,'right',f2,'left')
% iptwindowalign(f1,'bottom',f2,'bottom')