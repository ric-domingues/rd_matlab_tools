function [U,V,lon,lat,ADT]=read_aviso_data_uv_data(file,LON_LIM,LAT_LIM);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

nc=ncload(file)

%  u = u*0.0001;
%  v = v*0.0001;

u = double(nc.ugos)'*0.0001;
v = double(nc.vgos)'*0.0001;
adt = double(nc.adt)'*0.0001;

lon = double(nc.longitude);
lat = double(nc.latitude);

Klon = find(lon>180);

lon(Klon) = lon(Klon)-360;

[lon,Ilon] = sort(lon);

K = find(u<-1e3);
u(K)=nan;
v(K) = nan;
adt(K) = nan;

u = u(:,Ilon);
v = v(:,Ilon);
adt = adt(:,Ilon);

Klon = find(lon>=LON_LIM(1) & lon<=LON_LIM(2));
Klat = find(lat>=LAT_LIM(1) & lat<=LAT_LIM(2));

lon = lon(Klon);
lat = lat(Klat);

V = v(Klat,Klon);
U = u(Klat,Klon);
ADT = adt(Klat,Klon);

[lon,lat] = meshgrid(lon,lat);

% pcolor(lon,lat,ADT), shading flat, colorbar;
% pause


