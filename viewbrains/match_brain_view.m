%% match_brain_view.m
% Bingxing Huo, Jan 2021
% This script displays the region of interest in mouse and marmoset
% input:
%   - species: either "mouse" or "marmoset"
%   - L: location of the matched regions in LUT
% output:
%   Two windows should show up, one of 3D visualization of the brains, another of coronal sections, both with the region highlighted.
% global variables:
%   - LUT: structure of lookup table across mouse and marmoset. Output from
%   LUTassemble.m
function match_brain_view(species,L)
global LUT mouselist marmosetlist specieslist
%% load atlases, both reference and annotation, and resolution for both species
load('atlas_for_vis');
%% 1. identify species-specific data
speciesi=ismember(specieslist,species); % primary species the user identified
species1=specieslist{~speciesi}; % candidate species to search for correspondence in
if strcmpi(species,'mouse') % user specified mouse region
    % primary: mouse
    primarylist=mouselist;
    primaryLUT=LUT.mouse;
    primaryrefatlas=mousetemplate;
    primaryannoatlas=mouseanno;
    primaryres=mouseres;
    % search: marmoset
    searchlist=marmosetlist;
    searchLUT=LUT.marmoset;
    searchrefatlas=marmosettemplate2;
    searchannoatlas=marmosetanno2;
    searchres=marmosetres;
elseif strcmpi(species,'marmoset') % user specified marmoset region
    % primary: marmoset
    primarylist=marmosetlist;
    primaryLUT=LUT.marmoset;
    primaryrefatlas=marmosettemplate2;
    primaryannoatlas=marmosetanno2;
    primaryres=marmosetres;
    % search: mouse
    searchlist=mouselist;
    searchLUT=LUT.mouse;
    searchrefatlas=mousetemplate;
    searchannoatlas=mouseanno;
    searchres=mouseres;
end
%% 2. Get region information
% 2.1 get all information of the primary region(s) in LUT
primaryid=cell2mat(primaryLUT(L,1)');
primaryregioninfo=getregioninfo(primarylist,primaryid);
if size(primaryregioninfo,1)>3
    disp(['Note: showing only 3 of ',num2str(size(primaryregioninfo,1)),' names.'])
    primaryregioninfo=primaryregioninfo(1:3,:);
end
% primaryid1l=allchildren(primarylist,primaryid);
% to control colors, go through each row in LUT
primaryid1=[];
for li=1:length(L)
    primaryid1l=allchildren(primarylist,primaryLUT{L(li),1});
    primaryid1l=nonzeros(primaryid1l);
    if ~isempty(primaryid1l)
        primaryid1l(:,2)=li;
        primaryid1=[primaryid1;primaryid1l];
    end
end
% 2.2 get all information of the corresponding regions read from LUT
searchid=cell2mat(searchLUT(L,1)');
if ~isempty(searchid)
    searchregioninfo=getregioninfo(searchlist,searchid);
    if size(searchregioninfo,1)>3
        disp(['Note: showing only 3 of ',num2str(size(searchregioninfo,1)),' names.'])
        searchregioninfo=searchregioninfo(1:3,:);
    end
    %     searchid1=allchildren(searchlist,searchid);
    searchid1=[];
    for li=1:length(L)
        searchid1l=allchildren(searchlist,searchLUT{L(li),1});
        searchid1l=nonzeros(searchid1l);
        if ~isempty(searchid1l)
            searchid1l(:,2)=li;
            searchid1=[searchid1;searchid1l];
        end
    end
else
    disp('No homology found.')
end
%% 3. visualization
%% 3.1 3D visualization
f1=figure;
% 3.1.1 primary brain
subplot(1,2,1); h1=gca; % Panel 1
h1=brainvis3d(primaryannoatlas,h1,[],primaryres); % brain in 3D
primaryidV=region3doverlay(h1,primaryannoatlas,primaryid1(:,1),primaryres,primaryid1(:,2));
camlight
lighting gouraud
ifanno1=sum(sum(sum(primaryidV)));
if ifanno1>0
    title([{species};join(primaryregioninfo(:,3),',',2)])
else
    title([{species};join(primaryregioninfo(1,3),',',2);{'region(s) not annotated'}])
end
% 3.1.2 corresponding brain
subplot(1,2,2); h2=gca; % Panel 2
h2=brainvis3d(searchannoatlas,h2,[],searchres); % show the corresponding brain
if ~isempty(searchid) % there is corresponding region in LUT
    searchidV=region3doverlay(h2,searchannoatlas,searchid1(:,1),searchres,searchid1(:,2));
    ifanno2=sum(sum(sum(searchidV)));
    if ifanno2>0
        title([{species1};join(searchregioninfo(:,3),',',2)])
    else
        title([{species1};join(searchregioninfo(1,3),',',2);{'region(s) not annotated'}])
    end
else
    title([{species1};'no homologous region'])
    ifanno2=[];
end
camlight
lighting gouraud
% 3.1.3 link the two panels
Link = linkprop([h1, h2],{'CameraUpVector', 'CameraPosition', 'CameraTarget'});
setappdata(gcf, 'StoreTheLink', Link);
%% 3.2 visualize in coronal section
f2=figure;
% 3.2.1 primary
h3=subplot(1,2,1);
if ifanno1>0
    regioncoronaloverlay(h3,primaryrefatlas,primaryidV,primaryid1(:,1),primaryid1(:,2));        % display the coronal section with individual regions overlaid
    hold(h3,'on')
    line([10,10+5/primaryres(1)],[10 10],'linewidth',2,'color','w') % scale bar of 5mm
    text(10,5,'5mm','color','w')
    title([species;join(primaryregioninfo(:,3),',',2)])
else % no annotation available
    imagesc(zeros(size(primaryrefatlas(:,:,1)))) % show black section
    colormap gray
    axis image; axis off
    title([{species};join(primaryregioninfo(1,3),',',2);{'region(s) not annotated'}])
    disp(cell2mat([join(primaryregioninfo(1,3),','),' in ',species,' and subregions are not annotated. ']));
    % suggestion:
    if ~isempty(primaryid1) % region not found in LUT
        disp('Please consider select following parent regions: ')
        PP=[];
        for p=1:length(primaryid1)
            PP=[PP;lineageinfo(primarylist,primaryid1(p),0)];
        end
        PPid=cell2mat(PP(:,4));
        [~,PPidui]=unique(PPid);
        PP1=PP(PPidui,[4,2,3]);
        [~,sorti]=sort(cell2mat(PP(PPidui,1)));
        disp(cell2table(PP1(sorti,:),'VariableNames',{'regionID','acronym','regionname'}))
    end
end
% 3.2.2 corresponding
h4=subplot(1,2,2);
if ifanno2>0
    regioncoronaloverlay(h4,searchrefatlas,searchidV,searchid1(:,1),searchid1(:,2));        % display the coronal section with individual regions overlaid
    title([species1;join(searchregioninfo(:,3),',',2)])
    hold(h4,'on')
    line([10,10+5/searchres(1)],[10 10],'linewidth',2,'color','w')  % scale bar of 5mm
    text(10,5,'5mm','color','w')
else % 0 means no annotation
    imagesc(zeros(size(searchrefatlas(:,:,1)'))) % show black image
    colormap gray
    axis image; axis off
    if isempty(ifanno2) % empty means not found
        title(['No homologous region in ',species1])
    else
        title([{species1};join(searchregioninfo(1,3),',',2);{'region(s) not annotated'}])
    end
end
iptwindowalign(f1,'right',f2,'left')
iptwindowalign(f1,'bottom',f2,'bottom')
end

function idV=region3doverlay(h,annoatlas,idlist,atlasres,colorlist)
regioncolors=lines; % set up colors for different regions
if nargin>4
    regioncolors=regioncolors(colorlist,:); % set up colors for different regions
end
% show individual brain regions and assign colors on top of the 3D brain
idV=zeros(size(annoatlas));
for i=1:length(idlist)
    tmpvol=ismember(annoatlas,idlist(i));
    idV=idV+tmpvol*i; % one index for each region
end
ifanno=sum(sum(sum(idV)));
if ifanno>0
    n=0;
    for i=1:length(idlist)
        n=n+1;
        brainvis3d(idV==i,h,regioncolors(n,:),atlasres);
    end
end
end

function regioncoronaloverlay(h,refatlas,idV,idlist,colorlist)
regioncolors=lines; % set up colors for different regions
if nargin>4
    regioncolors=regioncolors(colorlist,:); % set up colors for different regions
end
if sum(sum(sum(idV)))>0
    K1=squeeze(sum(sum(idV,1),2)); % get total voxels for all Z
    [~,K1i]=max(K1); % find the section with largest area annotated
    imagesc(h,refatlas(:,:,K1i)')
    colormap gray
    idmask=idV(:,:,K1i)';
    % show individual brain regions and assign colors on top of the
    % coronal section
    n=0;
    for i=1:length(idlist)
        n=n+1;
        transparent_overlay(gca,idmask==i,regioncolors(n,:));
    end
    axis image; axis off
end
end