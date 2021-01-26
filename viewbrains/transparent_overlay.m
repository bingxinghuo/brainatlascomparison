function h=transparent_overlay(axhandle,overimg,color,alpha)
if nargin<3
    color='g';
    alpha=.5;
end
if nargin<4
    alpha=.5;
end
overimg=single(overimg)/single(max(max(overimg)));
if isa(color,'char')
    if strcmpi(color,'r')
        mask=cat(3,ones(size(overimg)),zeros(size(overimg)),zeros(size(overimg)));
    elseif strcmpi(color,'g')
        mask=cat(3,zeros(size(overimg)),ones(size(overimg)),zeros(size(overimg)));
    elseif strcmpi(color,'b')
        mask=cat(3,zeros(size(overimg)),zeros(size(overimg)),ones(size(overimg)));
    else
        disp('Not supporting this string input. Please choose from "r","g","b" or specify a 3-element color vector instead.')
    end
elseif isa(color,'numeric')
    if length(color)~=3
        disp('Color vector should be a 3-element vector.')
    else
        mask=cat(3,ones(size(overimg))*color(1),ones(size(overimg))*color(2),ones(size(overimg))*color(3));
    end
end
hold(axhandle,'on');
h=imagesc(mask);
set(h,'AlphaData',single(overimg)*alpha)