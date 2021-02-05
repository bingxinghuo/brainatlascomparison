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
global LUT
%% identify LUT
% species='mouse';
if strcmpi(species,'mouse')
    load('mouseregionlist');
    primarylist=mouselist;
    primaryLUT=LUT.mouse;
elseif strcmpi(species,'marmoset')
    load('marmosetregionlist');
    primarylist=marmosetlist;
    primaryLUT=LUT.marmoset;
end
%% search in LUT
% region=84;
if ~isa(region,'numeric')
    region1=findregionid(primarylist,region);
    if isempty(region1)
        region1=findregionid(primarylist,region,1);
    end
    region=region1;
end
regioninfo=childreninfo(primarylist,region,0,0);
disp(['Searching for ',regioninfo{3},' and subregions in lookup table.'])
%
L=LUTleaves(primarylist,primaryLUT,region);
if isempty(L)
    disp('Region not a leaf-level structure!')
    % look for all subregions
    RR=allchildren(primarylist,region);
    RL=cell(length(RR),1);
    for r=1:length(RR)
        RL{r}=LUTleaves(primarylist,primaryLUT,RR(r));
    end
    L=cell2mat(RL);
    if isempty(L)
        disp('Cannot find region or subregion in lookup table!')
    else
        L=unique(L);
    end
end
end

%%
function L=LUTleaves(animallist,animalLUT,regionid)
N=size(animalLUT,1);
loc=zeros(N,1);
for i=1:N
    if ~isempty(animalLUT{i})
        CC=allchildren(animallist,animalLUT{i});
        loc(i)=sum(ismember(regionid,CC));
    end
end
L=find(loc);
end
