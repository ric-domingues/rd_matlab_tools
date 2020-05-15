function [V,U]=get_vgeo1D(X,Y,DYN);

%  function [V,U]=get_vgeo1D(X,Y,DYN);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	This function calculates the cross geostrophic velocity
%		based on a dynamic height distribution
%			
%		requires:
%  			- Sea Water package
%	
%		Ricardo M. Domingues, AOML/NOAA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
V=0;
%============================================================================
% initial parameters

[m,n]=size(Y);

DX = sw_dist(X,Y,'km')*1e3;%m
DIST_ref = [0,cumsum(DX)];
DIST_grad = DIST_ref(1:end-1) + diff(DIST_ref)./2;

g = sw_g(Y,zeros(m,n));
f = sw_f(Y);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CALCULATING THE VGEO

dPdX = diff(DYN)./DX;
dP_V = interp1(DIST_grad,dPdX,DIST_ref);





U = -(g./f).*dP_V;
V = (g./f).*dP_V;




%  
%  MASK = find(Y2>-5 & Y2<5);
%  U(MASK)=nan;
%  V(MASK)=nan;
%  
%  Vel = sqrt(U.^2 + V.^2);

%  pcolor(X,Y,Vel),shading flat, hold on
%  quiver(X,Y,U,V,'k');
















