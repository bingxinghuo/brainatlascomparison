%% match_atlas_visual.m
% Bingxing Huo, Jan 2021
% updated Nov 2021 to incorporate multiple regions
% This script searches for a brain region in either marmoset or mouse, and
% display the counterpart in the other species
% input:
%   - species: either "mouse" or "marmoset"
%   - regions: a n-by-1 cell, each cell contains either string of region name or acronym, or the region ID.
%   - ifdescend: flag (default = 0) for whether to look in the region's
%   children for a match in the lookup table.
% output:
%   - L: location of the matched regions in LUT
function [Ls,regions]=search_in_LUT(speciesinfo,regions,ifdescend)
global LUT
if isempty(LUT)
    load('brainmatchatlas.mat','LUT')
end
%% identify LUT
% species='mouse';
if strcmpi(speciesinfo,'mouse')
    load('mouseregionlist');
    primarylist=mouselist;
    primaryLUT=LUT.mouse;
elseif strcmpi(speciesinfo,'marmoset')
    load('marmosetregionlist');
    primarylist=marmosetlist;
    primaryLUT=LUT.marmoset;
end
if nargin<3
    ifdescend=0;
end
%% search in LUT
Ls=cell(length(regions),1);
for i=1:length(regions)
    region=regions{i};
    if ~isa(region,'numeric')
        region1=findregionid(primarylist,region);
        if region1==0
            region1=findregionid(primarylist,region,1);
        end
        region=region1;
    end
    regioninfo=childreninfo(primarylist,region,0,0);
    disp(['Searching for ',regioninfo{3},' and subregions in lookup table.'])
    %
    L=LUTleaves(primarylist,primaryLUT,region);
    if isempty(L) && ifdescend>0
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
            Ls{i}=L;
        end
    else
        Ls{i}=L;
    end
    
end
Ls=cell2mat(Ls);
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
