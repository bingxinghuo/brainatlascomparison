function h=brainvis3d(brainvol,h0,color,res)
[X,Y,Z]=size(brainvol);
[XX,YY,ZZ]=meshgrid(1:Y,1:X,1:Z);
V=brainvol>0;
fv=isosurface(V*2,1);
if nargin<2 || isempty(h0)
    figure
    h=gca;
else
    h=h0;
    hold on;
end
p=patch(h,fv);
p.EdgeColor='none';
if nargin<3 || isempty(color)
    p.FaceColor=[.99 .99 .99];
else
    p.FaceColor=color;
end
p.FaceVertexAlphaData=.3;
p.FaceAlpha='flat';
p.AlphaDataMapping='none';
if nargin<2 || isempty(h0)
    camlight
    lighting gouraud % only set lighting for new figure
end
axis tight
if nargin<4 || isempty(res)
    daspect([1 1 1])
else
    daspect(res) % aspect ratio based on resolution
end
view(3)