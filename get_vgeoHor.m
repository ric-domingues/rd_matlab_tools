function [U,V]=get_vgeoHor(X,Y,DYN);

%  function [U,V]=get_vgeoHor(X,Y,DYN);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	This function calculates the horizontal geostrophic velocity field
%		based on a dynamic height distribution
%			
%		requires:
%  			- Sea Water package
%	
%		Ricardo M. Domingues, AOML/NOAA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%============================================================================
% initial parameters
X=unique(X)';
Y=unique(Y)';

Ygrad = Y(1:end-1) + diff(Y)/2;
Xgrad = X(1:end-1) + diff(X)/2;

for i=1:length(X)
	DY(:,i) = sw_dist(Y,X(i)*ones(1,length(Y)),'km')*1000; %m
end

for i=1:length(Y)
	DX(i,:) = sw_dist(Y(i)*ones(1,length(X)),X,'km')*1000; %m
end
%  imagesc(DX)

[X2,Y2]=meshgrid(X,Y);
[m,n]=size(X);

g = sw_g(Y2,zeros(m,n));
f = sw_f(Y2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CALCULATING THE VGEO

dPdY = diff(DYN,1,1)./DY;
dPdX = diff(DYN,1,2)./DX;

dP_U = interp2(X,Ygrad',dPdY,X,Y');
dP_V = interp2(Xgrad,Y',dPdX,X,Y');

U = -(g./f).*dP_U;
V = (g./f).*dP_V;

MASK = find(Y2>-5 & Y2<5);
U(MASK)=nan;
V(MASK)=nan;

Vel = sqrt(U.^2 + V.^2);

%  pcolor(X,Y,Vel),shading flat, hold on
%  quiver(X,Y,U,V,'k');
















