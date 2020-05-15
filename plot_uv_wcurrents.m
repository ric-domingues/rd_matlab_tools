function [ ret ] = plot_ssh_wcurrents(fileuv,fileout,DX_DRIFT,INT_DX,LON_LIM,LAT_LIM)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  			Ricardo Domingues, AOML/NOAA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ret.code=0;
try
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp(' Read AVISO data')

[u,v,x,y,adt] = read_aviso_uv_data(fileuv,LON_LIM,LAT_LIM);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

lon_ref = nanmin(x(:)):INT_DX:nanmax(x(:));
lat_ref = nanmin(y(:)):INT_DX:nanmax(y(:));

[lon2,lat2] = meshgrid(lon_ref,lat_ref);

U = interp2(x,y,u,lon2,lat2);
V = interp2(x,y,v,lon2,lat2);
ADT= interp2(x,y,adt,lon2,lat2);

Vel=sqrt(U.^2 + V.^2);

Z = get_bathy2grid(lon2,lat2);
Kz = find(Z>0);
U(Kz) = NaN;
V(Kz) = NaN;

map2gmt(lon2,lat2,U,12,1,fileout);
map2gmt(lon2,lat2,V,13,1,fileout);
map2gmt(lon2,lat2,Vel,21,1,fileout);
map2gmt(lon2,lat2,ADT,22,1,fileout);

[MM,NN] = size(U)
lonAUX = nanmin(x(:)):DX_DRIFT:nanmax(x(:));
latAUX = nanmin(y(:)):DX_DRIFT:nanmax(y(:));
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
