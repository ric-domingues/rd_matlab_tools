function [X,Y,Z]=plot_bathymetry_3D(LON_LIM,LAT_LIM,S,CAM_ANGLE);

% [X,Y,Z]=plot_bathymetry_3D(LON_LIM,LAT_LIM,S,CAM_ANGLE);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  	This function plot the batimetry 3D for the region 				%
%  		based on etopo5								%
%   											%
%		Input: 									%
%			LON_LIM - longitude limits (e.g [minlon maxlon])		%
%			LAT_LIM - latitude limits (e.g [minlat maxlat])			%
%			S - degree of smoothing to the batimetry (not required)		%
%  			CAM_ANGLE - observing camera angle (not required)		%
%  											%
%		Requires:								%
%			- FreezeColors						    	%
%										    	%
%  		Ricardo Domingues, AOML/NOAA					    	%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

AX=gca;hold on
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% extracting the batimetry 

load etopo5
load Bathymetry_cmap

if(~exist('CAM_ANGLE'))
	CAM_ANGLE = [366.3345 -201.2550 6.1711e+04];
end

if(~exist('S'))
	S=4;
end

if(S<1)
	S=1;
end

[J_LIM] = find(x>=LON_LIM(1) & x<=LON_LIM(2));
[I_LIM] = find(y>=LAT_LIM(1) & y<=LAT_LIM(2));

x=x(J_LIM);
y=y(I_LIM);
z=z(I_LIM,J_LIM);
IND_z = find(z>0);

for i=1:S
z = smo(z);
end
z(IND_z) = 10;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ploting

%  figure
%  PL=auto_plot(1,1,1,1,.7,1,1,8,8);
colormap(cmap)
surf(x,y,z),shading interp, hold on

MAXDEPTH = (ceil(nanmin(z(:))./1000))*1000;
caxis([MAXDEPTH 0])
view(3)
daspect([.1 .1 40])
xlim(LON_LIM)
ylim(LAT_LIM)
zlim([(MAXDEPTH+MAXDEPTH*.2) 10])
if(exist('CAM_ANGLE'))
	set(gca,'CameraPosition',CAM_ANGLE)
end
grid on
set(gca,'box','off')


freezeColors


