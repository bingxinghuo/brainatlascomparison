%% match_brain_view.m
% Bingxing Huo, Jan 2021
% This script displays the region of interest in mouse and marmoset
% input:
%   - LUT: structure of lookup table across mouse and marmoset. Output from
%   LUTassemble.m
%   - species: either "mouse" or "marmoset"
%   - L: location of the matched regions in LUT
% output:
%   Two windows should show up, one of 3D visualization of the brains, another of coronal sections, both with the region highlighted.
function match_brain_view(species,L)
global LUT region mouselist marmosetlist
%% load atlases
load('atlas_for_vis');
% load('mouseregionlist');
% load('marmosetregionlist');
% load mouse atlas
% [mousetemplate,mouseanno]=loadatlas('mouse',100); % 100um atlas
% load marmoset atlas
% [marmosettemplate,marmosetanno]=loadatlas('marmoset'); % 40X40X112 um^3
% marmosetanno1=imresize3(marmosetanno,[113,167,105],'nearest'); % 240x240x224 um^3
% marmosetanno2=permute(marmosetanno1,[1,3,2]); % to be consistent with mouse orientation
% marmosetanno2=flip(marmosetanno2,2);
% marmosettemplate1=imresize3(marmosettemplate,[113,167,105],'nearest'); % 240x240x224 um^3
% marmosettemplate2=permute(marmosettemplate1,[1,3,2]); % to be consistent with mouse orientation
% marmosettemplate2=flip(marmosettemplate2,2);
%%
specieslist={'mouse';'marmoset'};
speciesi=ismember(specieslist,species);
species1=specieslist{~speciesi};
if strcmpi(species,'mouse')
    primarylist=mouselist;
    primaryLUT=LUT.mouse;
    primaryrefatlas=mousetemplate;
    primaryannoatlas=mouseanno;
    primaryres=mouseres;
    searchlist=marmosetlist;
    searchLUT=LUT.marmoset;
    searchrefatlas=marmosettemplate2;
    searchannoatlas=marmosetanno2;
    searchres=marmosetres;
elseif strcmpi(species,'marmoset')
    primarylist=marmosetlist;
    primaryLUT=LUT.marmoset;
    primaryrefatlas=marmosettemplate2;
    primaryannoatlas=marmosetanno2;
    primaryres=marmosetres;
    searchlist=mouselist;
    searchLUT=LUT.mouse;
    searchrefatlas=mousetemplate;
    searchannoatlas=mouseanno;
    searchres=mouseres;
end
%% get all subregions
primaryid=cell2mat(primaryLUT(L,1)');
for i=1:length(primaryid)
    primaryregioninfo(i,:)=childreninfo(primarylist,primaryid(i),0,0);
end
if size(primaryregioninfo,1)>3
    disp(['Note: showing only 3 of ',num2str(size(primaryregioninfo,1)),' names.'])
    primaryregioninfo=primaryregioninfo(1:3,:);
end
primaryid1=allchildren(primarylist,primaryid);
%
searchid=cell2mat(searchLUT(L,1)');
if ~isempty(searchid)
    for i=1:length(searchid)
        searchregioninfo(i,:)=childreninfo(searchlist,searchid(i),0,0);
    end
    if size(searchregioninfo,1)>3
        disp(['Note: showing only 3 of ',num2str(size(searchregioninfo,1)),' names.'])
        searchregioninfo=searchregioninfo(1:3,:);
    end
end
searchid1=allchildren(searchlist,searchid);
%% visualize in 3D
regioncolors=lines;
f1=figure;
% primaryidV=ismember(primaryannoatlas,region);
primaryidV=zeros(size(primaryannoatlas));
ifanno1=sum(sum(sum(primaryidV)));
if ifanno1>0 % add in the parent region name
    primaryregioninfo=[childreninfo(primarylist,region,0,0);primaryregioninfo];
end
for i=1:length(primaryid1)
    primaryidV=primaryidV+ismember(primaryannoatlas,primaryid1(i))*i;
end
subplot(1,2,1); h1=gca;
ifanno1=sum(sum(sum(primaryidV)));
h1=brainvis3d(primaryannoatlas,h1,[],primaryres);
if ifanno1>0
    n=0;
    for i=1:length(primaryid1)
        n=n+1;
        brainvis3d(primaryidV==i,h1,regioncolors(n,:),primaryres);
    end
    camlight
    lighting gouraud
    title([{species};join(primaryregioninfo(:,3),',',2)])
else
    camlight
    lighting gouraud
    title([{species};join(primaryregioninfo(1,3),',',2);{'region(s) not annotated'}])
end
searchidV=zeros(size(searchannoatlas));
for i=1:length(searchid1)
    searchidV=searchidV+ismember(searchannoatlas,searchid1(i))*i;
end
ifanno2=sum(sum(sum(searchidV)));
subplot(1,2,2); h2=gca;
h2=brainvis3d(searchannoatlas,h2,[],searchres);
if ifanno2>0
    n=0;
    for i=1:length(searchid1)
        n=n+1;
        brainvis3d(searchidV==i,h2,regioncolors(n,:),searchres);
    end
    camlight
    lighting gouraud
    title([{species1};join(searchregioninfo(:,3),',',2)])
else
    camlight
    lighting gouraud
    title([{species1};join(searchregioninfo(1,3),',',2);{'region(s) not annotated'}])
end
Link = linkprop([h1, h2],{'CameraUpVector', 'CameraPosition', 'CameraTarget'});
setappdata(gcf, 'StoreTheLink', Link);
%% visualize in coronal section
f2=figure;
subplot(1,2,1)
if ifanno1>0
    if ~isempty(primaryid1)
        K1=squeeze(sum(sum(primaryidV,1),2));
        [~,K1i]=max(K1);
        imagesc(primaryrefatlas(:,:,K1i)')
        colormap gray
        primaryidmask=primaryidV(:,:,K1i)';
        n=0;
        for i=1:length(primaryid1)
            n=n+1;
            transparent_overlay(gca,primaryidmask==i,regioncolors(n,:));
        end
        axis image; axis off
        hold on, line([10,10+5/primaryres(1)],[10 10],'linewidth',2,'color','w')
        text(10,5,'5mm','color','w')
        
        title([species;join(primaryregioninfo(:,3),',',2)])
    else
        title(['No matched region in ',species])
    end
else
    imagesc(zeros(size(primaryrefatlas(:,:,1))))
    colormap gray
    axis image; axis off
    title([{species};join(primaryregioninfo(1,3),',',2);{'region(s) not annotated'}])
    disp(cell2mat([join(primaryregioninfo(1,3),','),' in ',species,' and subregions are not annotated. ']));
    if ~isempty(primaryid1)
        disp('Please consider following parent regions: ')
        PP=[];
        for p=1:length(primaryid1)
            PP=[PP;lineageinfo(primarylist,primaryid1(p),0)];
        end
        PPid=cell2mat(PP(:,4));
        [~,PPidui]=unique(PPid);
        PP1=PP(PPidui,[4,2,3]);
        disp(cell2table(PP1,'VariableNames',{'regionID','acronym','regionname'}))
    end
end
%
subplot(1,2,2)
if ifanno2>0
    if ~isempty(searchid1)
        K1=squeeze(sum(sum(searchidV,1),2));
        [~,K1i]=max(K1);
        imagesc(searchrefatlas(:,:,K1i)')
        colormap gray
        searchidmask=searchidV(:,:,K1i)';
        n=0;
        for i=1:length(searchid1)
            n=n+1;
            transparent_overlay(gca,searchidmask==i,regioncolors(n,:));
        end
        axis image; axis off
        hold on, line([10,10+5/searchres(1)],[10 10],'linewidth',2,'color','w')
        text(10,5,'5mm','color','w')
        title([species1;join(searchregioninfo(:,3),',',2)])
    else
        title(['No matched region in ',species1])
    end
else
    imagesc(zeros(size(searchrefatlas(:,:,1))))
    colormap gray
    axis image; axis off
    title([{species1};join(searchregioninfo(1,3),',',2);{'region(s) not annotated'}])
end
iptwindowalign(f1,'right',f2,'left')
iptwindowalign(f1,'bottom',f2,'bottom')