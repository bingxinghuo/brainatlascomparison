%% match_atlas_visual.m
% Bingxing Huo, Jan 2021
% This script searches for a brain region in either marmoset or mouse, and
% display the counterpart in the other species
% input:
%   - LUT: structure of lookup table across mouse and marmoset. Output from
%   LUTassemble.m
%   - species: either "mouse" or "marmoset"
%   - region: either string of region name or acronym, or the region ID.
% output:
%   - L: location of the matched regions in LUT
function [L,region]=search_in_LUT(species,region)
global LUT mouselist marmosetlist
%% identify species-specific data
% species='mouse';
if strcmpi(species,'mouse')
    primarylist=mouselist;
    primaryLUT=LUT.mouse;
elseif strcmpi(species,'marmoset')
    primarylist=marmosetlist;
    primaryLUT=LUT.marmoset;
end
%% search in LUT
% 1. find region ID in the atlas
region=findregionid(primarylist,region);
if region==0
    L=[];
else
    regioninfo=getregioninfo(primarylist,region); % retrieve region information
    % 2. find region in the LUT
    disp(['Searching for ',regioninfo{3},' and subregions in lookup table.'])
    % 2.1 search through subregions of LUT for the region
    L=LUTleaves(primarylist,primaryLUT,region); %
    % 2.2 search through all subregions in the LUT
    if isempty(L)
        disp('Region not a leaf-level structure!')
        % look for all subregions
        RR=allchildren(primarylist,region); % get all subregions of the region, including itself
        % for each subregion, search in LUT
        RL=cell(length(RR),1);
        for r=1:length(RR)
            RL{r}=LUTleaves(primarylist,primaryLUT,RR(r));
        end
        L=cell2mat(RL);
        if isempty(L)
            disp('Cannot find region or subregion in lookup table!')
        else
            L=unique(L); % gather a collection of regions in LUT corresponding to the candidate region
        end
    end
end
end

%% search for regionid in the lookup table by searching through all subregions
function L=LUTleaves(animallist,animalLUT,regionid)
N=size(animalLUT,1);
loc=zeros(N,1);
for i=1:N
    if ~isempty(animalLUT{i})
        CC=allchildren(animallist,animalLUT{i}); % get all subregions for each region in LUT, including itself
        loc(i)=sum(ismember(regionid,CC)); % search for regionid within the subregions
    end
end
L=find(loc);
end
