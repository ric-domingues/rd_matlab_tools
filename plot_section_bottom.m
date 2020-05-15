function [XV,YV]=plot_section_bottom(lon_sec,lat_sec,BCOLOR,IORI)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  
%  	This function retrieves the bottom information and plot the bottom for an
%  		specific section
%  	
%  		IORI = 1 (by latitide); 2 (by longitude)
%  		BCOLOR = color for the bottom filling
%  
%  		Ricardo Domingues, AOML/NOAA
%  	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

LON_LIM=[nanmin(lon_sec)-1 nanmax(lon_sec)+1];
LAT_LIM=[nanmin(lat_sec)-1 nanmax(lat_sec)+1];

IDFIG=gcf;

figure(2738),clf
[X,Y,Z]=plot_bathymetry('s',0,LON_LIM,LAT_LIM,20,'k',1);
close(2738)

Zsec=interp2(X,Y,Z,lon_sec,lat_sec);

if(IORI==2);	
	YV=[Zsec,nanmin(Zsec),nanmin(Zsec),Zsec(1)];
	XV=[lon_sec,lon_sec(end),lon_sec(1),lon_sec(1)];
elseif(IORI==1)
	YV=[Zsec,nanmin(Zsec),nanmin(Zsec),Zsec(1)];
	XV=[lat_sec,lat_sec(end),lat_sec(1),lat_sec(1)];
end
	
figure(IDFIG)
fill(XV,YV,BCOLOR)













