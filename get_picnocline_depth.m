function [Depth] = get_picnocline_depth(T,S,Z);

%  function [Depth] = get_picnocline_depth(T,S,Z);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	Gets the depth of maximum density change  
%  
%  			Depth (m);
%    		Ricardo Domingues, AOML/NOAA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Depth=nan;

DENS0 = sw_dens0(S,T);

Z_i = nanmin(Z):1:nanmax(Z);
DENS_i = interp1(Z,DENS0,Z_i);

DENS_i = rmean(DENS_i,201);

dRHO_dz = diff(DENS_i);
Z_dz = Z_i(1:end-1) + diff(Z_i)/2; 

[max,Idepth] = nanmax(dRHO_dz);
Depth = Z_dz(Idepth); 

%  
%  plot(abs(stand_RD(dRHO_dz)),-Z_dz), hold on
%  plot(abs(stand_RD(DENS_i)),-Z_i,'r');



 




