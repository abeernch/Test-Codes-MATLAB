latMin = 5;
latMax = 50;
lonMin = 40;
lonMax = 88;
map=load('mapCropped.mat');
[ht,wd,~] = size(map.i);

latRange = latMax - latMin;
lonRange = lonMax - lonMin;

%% Convert geo coords to pixel coords
lon = 45;
lat =6;
x = round((lon - lonMin)/lonRange*(wd-1))+1;
y = round((latMax - lat)/latRange*(ht-1))+1;

%% Convert pixels to geo coords
syms x y lat lon latMax lonMin latRange lonRange wd ht eqn1 eqn2
eqn1 = ((lon - lonMin)/lonRange*(wd-1))+1 == x;
eqn2= ((latMax - lat)/latRange*(ht-1))+1 == y;
%% convert 
lon = (lonRange*(x + (lonMin*(wd - 1))/lonRange - 1))/(wd - 1);
lat = -(latMax - latRange - ht*latMax + latRange*y)/(ht - 1);