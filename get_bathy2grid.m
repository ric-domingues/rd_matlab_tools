function [Zbathy]=get_bathy2grid(LON,LAT,TOPO);

%  function [Zbathy]=get_bathy2grid(LON,LAT,TOPO);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	This function retrieve the BATHYMETRY for an specific GRID (LON,LAT)
%
%		ETOPO-1 (REMO)
%		
%		Ricardo Domingues, AOML/NOAA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if(~exist('TOPO'))
	TOPO = 5;
end

LON_LIM = [nanmin(LON(:)) nanmax(LON(:))];
LAT_LIM = [nanmin(LAT(:)) nanmax(LAT(:))];

figure(100110)
[X,Y,Z] = plot_bathymetry('cc',0,LON_LIM,LAT_LIM,10,'k',TOPO);
close(100110)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  interpolating

[m,n]=size(LON);

LON_aux = reshape(LON,1,m*n);
LAT_aux = reshape(LAT,1,m*n);

Z_aux = interp2(X,Y,Z,LON_aux,LAT_aux);
Zbathy = reshape(Z_aux,m,n);
