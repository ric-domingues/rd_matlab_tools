function [ ret ] = get_adt_currents(fileUV,area,fileout,DX_DRIFT)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  			Ricardo Domingues, AOML/NOAA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ret.code=0;
try
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  reading file
ncload(fileUV)
longitude(longitude>180) = longitude(longitude>180) - 360;
[longitude,Ilon] = sort(longitude);

adt = adt(:,Ilon)*0.0001;adt(adt<-1e3) = NaN;
ugos = ugos(:,Ilon)*0.0001;ugos(ugos<-1e3) = 0;
vgos = vgos(:,Ilon)*0.0001;vgos(vgos<-1e3) = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fileout

DX = 0.1;
%  DX_DRIFT=.4;
lon = area(1)-5:DX:area(2)+5;
lat = area(3)-5:DX:area(4)+5;
[lon2,lat2] = meshgrid(lon,lat);

adt_OUT=interp2(longitude,latitude,adt,lon2,lat2);
u =interp2(longitude,latitude,ugos,lon2,lat2);
v =interp2(longitude,latitude,vgos,lon2,lat2);
vel = sqrt(u.^2 + v.^2);

a = zeros(size(vel));
a(1:4:end,1:4:end) = 1;
a=logical(a);

%  pcolor(lon2,lat2,vel),shading flat, hold on
%  quiver(lon2(a),lat2(a),u(a),v(a));

map2gmt(lon2,lat2,adt_OUT,11,0,fileout);
map2gmt(lon2,lat2,vel,14,1,fileout);

lon = area(1)-5:.25:area(2)+5;
lat = area(3)-5:.25:area(4)+5;
[lon2,lat2] = meshgrid(lon,lat);
adt_OUT=interp2(longitude,latitude,adt,lon2,lat2);
u =interp2(longitude,latitude,ugos,lon2,lat2);
v =interp2(longitude,latitude,vgos,lon2,lat2);
[MM,NN] = size(u);
map2gmt(lon2,lat2,u,12,1,fileout);
map2gmt(lon2,lat2,v,13,1,fileout);


lonAUX = area(1):DX_DRIFT:area(2);
latAUX = area(3):DX_DRIFT:area(4);
[lonDR,latDR] = meshgrid(lonAUX,latAUX);
vector2gmt(lonDR(:),latDR(:),15,1,fileout);
vector2gmt(MM,NN,16,1,fileout);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
catch

	[ err_msg ] = get_err_msg;

	ret.code = -1;
        ret.msg = err_msg;

end 
