function plot_field_3D(T3D,LON3D,LAT3D,Z3D,LON_LIM,LAT_LIM,CAM_ANGLE)

%  function plot_sec_3D(Tsec,lon0,lat0,lon,lat,pres,LON_LIM,LAT_LIM,CAXT,CAXZ,CAM_ANGLE)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	This function plots sections in an 3D environment with underlying 
%		bathymetry.
%		
%		Input: 
%
%			Tsec - Temperature (tracer) section (2D) - T(z,x);
%			lon0 - original longitude (1D) - plots dots where data was collected;
%			lat0 - original latitude (1D) - plots dots where data was collected;
%			lon - Tsec reference longitude (1D)
%			lat - Tsec reference latitude (1D)
%			LON_LIM - longitude limits (e.g [minlon maxlon])
%			LAT_LIM - latitude limits (e.g [minlat maxlon])
%
%
%
%		Requires:
%			- FreezeColors
%
%
%		Ricardo M. Domingues, AOML/NOAA
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initial procedures
warning off 
%  
%  ZRES = 200;
%  
%  lat_aux = lat;
%  lon_aux = lon;
%  pres_aux = pres(:,1)';
%  
%  clear lon lat
%  
%  for i=1:ZRES
%  	lat(i,:) =lat_aux;
%   	lon(i,:) =lon_aux;
%  end


if(~exist('CAM_ANGLE'))
	CAM_ANGLE = [366.3345 -201.2550 6.1711e+04];
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



colormap(jet)
p2 = patch(isocaps(LON3D,LAT3D,-Z3D,T3D, -2.0001), 'FaceColor', 'interp', 'EdgeColor', 'none');
p = patch(isosurface(LON3D,LAT3D,-Z3D,T3D,0.05), 'FaceColor', 'interp', 'EdgeColor', 'none');
hold on
caxis([0 22])
view(3)
%  plot(lon0,lat0,'k.','markersize',1)
set(gca,'CameraPosition',CAM_ANGLE)

%  zlim([-8000 10])
%  daspect([.1 .1 30])
%  xlabel('\bf Longitude','fontsize',12)
%  ylabel('\bf Latitude','fontsize',12)
%  zlabel('\bf Depth [m]','fontsize',12)

