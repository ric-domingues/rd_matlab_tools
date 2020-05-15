function [ ret ] = get_BC34S_figs(area,fileout,DX_DRIFT)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  			Ricardo Domingues, AOML/NOAA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ret.code=0;
try
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
DX = 0.1;
%  DX_DRIFT=.4;
lon = area(1)-5:DX:area(2)+5;
lat = area(3)-5:DX:area(4)+5;
[lon2,lat2] = meshgrid(lon,lat);
[mdt,v,u] = get_mdt2grid(lon2,lat2);
mdt=inpaint_nans(mdt,5);

vel = sqrt(u.^2 + v.^2);

a = zeros(size(vel));
a(1:4:end,1:4:end) = 1;
a=logical(a);

%  pcolor(lon2,lat2,vel),shading flat, hold on
%  quiver(lon2(a),lat2(a),u(a),v(a));
%  pause

map2gmt(lon2,lat2,mdt,11,0,fileout);
map2gmt(lon2,lat2,vel,14,1,fileout);

lon = area(1)-5:.25:area(2)+5;
lat = area(3)-5:.25:area(4)+5;
[lon2,lat2] = meshgrid(lon,lat);
[mdt,v,u] = get_mdt2grid(lon2,lat2);

u=inpaint_nans(u,5);
v=inpaint_nans(v,5);
[MM,NN] = size(u)

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
