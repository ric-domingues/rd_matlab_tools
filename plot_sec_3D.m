function plot_sec_3D(FIELD,LON_LIM,LAT_LIM,CAXT,CAXZ,ETOPO,ASPCT,CAM_ANGLE,REFINFAC)

%  function plot_sec_3D(Tsec,lon0,lat0,lon,lat,pres,LON_LIM,LAT_LIM,CAXT,CAXZ,CAM_ANGLE)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	This function plots sections in an 3D environment with underlying 
%		bathymetry.
%		
%		Input: 
%			-FIELD.(below)
%				Tsec - Temperature (tracer) section (2D) - T(z,x);
	%			lon - Tsec reference longitude (1D)
%				lat - Tsec reference latitude (1D)
%  				pres - reference pressure (2D)- Z(z,x);
%			-LON_LIM - longitude limits (e.g [minlon maxlon])
%			-LAT_LIM - latitude limits (e.g [minlat maxlon])
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
%  
Tsec = FIELD.Tsec;
lon = FIELD.lon;
lat = FIELD.lat;
lon0 = FIELD.lon;
lat0 = FIELD.lat;
pres = FIELD.pres;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initial procedures
warning off 

ZRES = 200;

lat_aux = lat;
lon_aux = lon;
pres_aux = pres(:,1)';

clear lon lat

for i=1:ZRES
	lat(i,:) =lat_aux;
 	lon(i,:) =lon_aux;
end


if(~exist('CAM_ANGLE'))
	CAM_ANGLE = [366.3345 -201.2550 6.1711e+04];
end

if(~exist('ETOPO'))
	ETOPO = 5;
end

if(~exist('ASPCT'))
	ASPCT=[.1 .1 100];
end

if(~exist('REFINFAC'))
	REFINFAC = 1;
end

ZLIM = CAXZ;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Retrieving the Bathymetry

load etopo5
load Bathymetry_cmap

[x,y,z]=plot_bathymetry('s',0,LON_LIM,LAT_LIM,1000,'k',ETOPO,0);
% disp('here1')

[mmm,nnn]=size(x);

if(REFINFAC>1)

x2 = linspace(nanmin(x(:)),nanmax(x(:)),REFINFAC*nnn);
y2 = linspace(nanmin(y(:)),nanmax(y(:)),REFINFAC*mmm);
[x2,y2]=meshgrid(x2,y2);
z2 = interp2(x,y,z,x2,y2);

x=x2;
y=y2;
z=z2;
end

IND_z = find(z>0);

%  z(1:2:end,1:2:end)=nan;
%  z = inpaint_nans(z,5);

if(ETOPO==5)
	z = smoothn(z,20);
end

z(IND_z) = 10;
% disp('here2')
% figure
% PL=auto_plot(1,1,1,1,.7,1,1,8,8);

colormap(cmap)
surf(x,y,z),shading interp, hold on
%  surfl(x,y,z),shading interp, hold on, colormap(gray)

MAXDEPTH = (ceil(nanmin(z(:))./1000))*1000;
caxis(CAXZ)
freezeColors

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Getting Sigma cordinates

Depth_sec = interp2(x,y,z,lon_aux,lat_aux);

for i=1:length(lat_aux)

	T = Tsec(:,i);
	P = pres(:,i);

	[P,I]=unique(P);
	T=T(I);

	IND = find(P>=Depth_sec(i));
	if(isempty(IND))
		IND=length(P);
	else
		IND = IND(end);
	end

	P_aux = linspace(Depth_sec(i),0,ZRES);

	T_aux = interp1(P,T,P_aux);

	TSEC(:,i) = T_aux;

	PRESS(:,i) = P_aux;

end
	
% disp('here3')
%  pcolor(lat_aux,PRESS,TSEC);shading flat

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ploting the section

Tsec = inpaint_nans(Tsec,5);
%  TT(:,1,:) = Tsec';
TT(:,1,:) = TSEC';
TT(:,2,:) = TT(:,1,:);

lat_sec(:,1,:)=lat';
lat_sec(:,2,:)=lat';

lon_sec(:,1,:)=lon';
lon_sec(:,2,:)=lon'+0.1;

%  PP(:,1,:)=pres';
%  PP(:,2,:)=pres';

PP(:,1,:)=PRESS';
PP(:,2,:)=PRESS';

disp('here4')
colormap(jet)
%  p2 = patch(isocaps(lon_sec,lat_sec,PP,TT, -2.0001), 'FaceColor', 'flat', 'EdgeColor', 'none');
%  p = patch(isosurface(lon_sec,lat_sec,PP,TT,0.05), 'FaceColor', 'flat', 'EdgeColor', 'none');
GCA=gca;
surf(lon,lat,PRESS,TSEC), shading flat
hold on
caxis(CAXT)
view(3)
%  plot(lon0,lat0,'k.','markersize',1)
set(gca,'CameraPosition',CAM_ANGLE)
 
zlim(ZLIM)
daspect(ASPCT)
xlabel('\bf Longitude','fontsize',12)
ylabel('\bf Latitude','fontsize',12)
zlabel('\bf Depth [m]','fontsize',12)

% clear all