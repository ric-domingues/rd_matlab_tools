function V=get_vgeoSec(X,Y,Z,Salt,Temp,PREF);

%  function V=get_vgeoSec(X,Y,Z,Salt,Temp,PREF);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	This function calculates the cross geostrophic velocity
%		based on a TS section
%		
%  		Z is positive (vector, increases monotonically)
%
%		  
%    	
%		requires:
%  			- Sea Water package
%	
%		Ricardo M. Domingues, AOML/NOAA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
V=0;U=0;N_DX=250;DZ=1;DIGPL=0;
%============================================================================
% initial parameters

if(~exist('PREF'))
	PREF=750;
end
[m,n]=size(Y);
DX = sw_dist(Y,X,'km')*1e3;%m
DIST_ref = [0,cumsum(DX)];
[DX_ref,Z_ref]=meshgrid(DIST_ref,Z);
DIST_grad = DIST_ref(1:end-1) + diff(DIST_ref)./2;
[DX_grad,Z_grad]=meshgrid(DIST_grad,Z);

Coriolis = sw_f(Y);
Gravity = sw_g(Y,zeros(1,length(Y)));
rho0 = 1025; %kg/m3

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Interpolating
Temp = inpaint_nans(Temp,5);
Salt = inpaint_nans(Salt,5);
gpan= sw_gpan(Salt,Temp,Z_ref);

if DIGPL
close all
figure
pcolor(DIST_ref,-Z_ref,Salt),shading flat, colorbar
title('Salinity')

figure
pcolor(DIST_ref,-Z_ref,Temp),shading flat, colorbar
title('Temperature')

figure
pcolor(DIST_ref,-Z_ref,gpan),shading flat, colorbar
title('Geopotential Anomaly')

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  CALCULATING CROSS SECTION VELOCITY ACCORDING TO THERMAL WIND RELATION

vel = sw_gvel(gpan,Y,X);
Kz = find(Z_ref>=PREF);Kz=Kz(1);

for z = 1:length(Z)

	vel(z,:) = vel(z,:) - vel(Kz,:);

end

V = interp2(DX_grad,Z_grad,vel,DX_ref,Z_ref);
if(nanmean(Y)<0);
V=-V;
end


if DIGPL
figure
pcolor(DX_ref,-Z_ref,V),shading flat, colorbar
title('Geostrophic velocity')
caxis([-.3 .3])
end









%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

