function [ ret ] = get_landmask_ref(lonlatfile,outfile);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  	This function generates a reference landmask for the study region
%  	
%  		Ricardo Domingues, AOML/NOAA
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ret.code=0;

try

load(lonlatfile)
[lon_ref,lat_ref]=meshgrid(lon_ref,lat_ref);
LON_LIM = [nanmin(lon_ref(:)) nanmax(lon_ref(:))];
LAT_LIM = [nanmin(lat_ref(:)) nanmax(lat_ref(:))];

figure(1)
set(1,'visible','off')
[X,Y,Z]=plot_batimetry('s',0,LON_LIM,LAT_LIM,10);
close all

Zref=interp2(X,Y,Z,lon_ref,lat_ref);

Land = find(Zref>=0);

save(outfile,'Land')

catch

	[ err_msg ] = get_err_msg;

	ret.code = -1;
        ret.msg = err_msg;

end 
