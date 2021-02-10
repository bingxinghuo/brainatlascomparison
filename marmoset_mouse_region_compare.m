%% visualize regions in mouse and marmoset
% run this script to trigger finding corresponding regions in mouse and
% marmoset with visualization
addpath(genpath('./'))
warning off
%% 1. load necessary data 
global LUT region mouselist marmosetlist specieslist % cast as global variables 
load('brainmatchatlas.mat','LUT') % lookup table (LUT)
load('mouseregionlist','mouselist'); % mouselist
load('marmosetregionlist','marmosetlist'); % marmosetlist
%% 2. manually specify the speices and region
specieslist={'mouse';'marmoset'};
speciesi=input('Please select a species: mouse (1) or marmoset (2)? ');
species=specieslist{speciesi};
if speciesi==1
    disp('Please refer to <a href = "http://brainarchitecture.org/mouse-connectivity-home#tab-id-2">mouse brain hierarchy</a> to find leaf-level region names.')
elseif speciesi==2
    disp('Please refer to <a href = "http://marmoset.brainarchitecture.org/#tab-id-2">marmoset brain hierarchy</a> to find leaf-level region names.')
end
region=input(['Please enter a region in ',species,' (ID, acronym, or partial name): '],'s');
%% 3. find the region in LUT 
[L,region]=search_in_LUT(species,region); % convert region and find in LUT
if isempty(L)
    disp('Region and subregions do not exist in the lookup table! Abort.')
    return
end
%% 4. view brain regions in 3D
match_brain_view(species,L);
%% 5. view brain regions in the hierarchy
match_hierarchy_view(species,L);