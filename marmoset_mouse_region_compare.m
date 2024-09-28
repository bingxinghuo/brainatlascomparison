%% visualize regions in mouse and marmoset
% run this script to trigger finding corresponding regions in mouse and
% marmoset with visualization
function marmoset_mouse_region_compare()
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
    disp('All mouse brain regions names are available at http://brainarchitecture.org/mouse-connectivity-home#tab-id-2. (Please copy and paste to view.)')
elseif speciesi==2
    disp('All marmoset brain regions names are available at http://marmoset.brainarchitecture.org/#tab-id-2. (Please copy and paste to view.)')
end
disp(['Please enter a region in ',species,' (ID, acronym, or partial name)'])
regions=input('if multiple regions, use , to separate: ','s');
regions= regions(~isspace(regions));
regions=split(regions,',');
%% 3. find the region in LUT 
[L,region]=search_in_LUT(species,regions,1); % convert region and find in LUT
if isempty(L)
    disp('Region and subregions do not exist in the lookup table! Abort.')
    return
end
%% 4. view brain regions in 3D
% if length(L)==1
    match_brain_view(species,L);
% else
%     match_brain_view_multi(species,L);
% end
%% 5. view brain regions in the hierarchy
load('mouseregionlist','mouselist1'); % mouselist
mouselist=mouselist1;
match_hierarchy_view(species,L);