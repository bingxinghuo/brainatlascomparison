%% visualize regions in mouse and marmoset
addpath(genpath('./'))
warning off
global LUT region mouselist marmosetlist
load('brainmatchatlas.mat') % LUT
load('mouseregionlist'); % mouselist
load('marmosetregionlist'); % marmosetlist
specieslist={'mouse';'marmoset'};
speciesi=input('Please select a species: mouse (1) or marmoset (2)? ');
species=specieslist{speciesi};
if speciesi==1
    disp('Please refer to <a href = "http://brainarchitecture.org/mouse-connectivity-home#tab-id-2">mouse brain hierarchy</a> to find leaf-level region names.')
elseif speciesi==2
    disp('Please refer to <a href = "http://marmoset.brainarchitecture.org/#tab-id-2">marmoset brain hierarchy</a> to find leaf-level region names.')
end
region=input(['Please enter a region in ',species,' (ID, acronym, or partial name): '],'s');
region1=str2num(region);
if ~isempty(region1)
    region=region1;
end
[L,region]=search_in_LUT(species,region); % convert region and find in LUT
if isempty(L)
    return
end
% view brain regions in 3D
match_brain_view(species,L);
% view brain regions in the hierarchy
match_hierarchy_view(species,L);