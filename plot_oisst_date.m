function [ ret ] = plot_oisst_date(file,plotdir);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	This function plots an specific OISST date  
%  
%  			Ricardo Doingues, AOML/NOAA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ret.code=0;

try
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

MT=load(file);
time = num2str(MT(1,1));
date = [time(5:6),'-',time(7:8),'-',time(1:4)]

lon0 = MT(:,2);
lat0 = MT(:,3);
sst0 = MT(:,4);

lon_ref = nanmin(lon0):.25:nanmax(lon0);
lat_ref = nanmin(lat0):.25:nanmax(lat0);
[lon_ref,lat_ref]=meshgrid(lon_ref,lat_ref);

bin = bin2d(lon0,lat0,sst0,lon_ref,lat_ref);
sst = bin.mean;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plotting

pcolor(lon_ref,lat_ref,sst),shading interp, colorbar
pause;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
catch

	[ err_msg ] = get_err_msg;

	ret.code = -1;
        ret.msg = err_msg;

end 
