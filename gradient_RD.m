function [dPDX,dPDY]=gradient_RD(X,Y,DYN);

%  function [dPDY,dPDX]=gradient_RD(X,Y,DYN);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	This function calculates the horizontal gradient of the specified variable			
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
	DY(:,i) = diff(Y);
end

for i=1:length(Y)
	DX(i,:) = diff(X);
end


[X2,Y2]=meshgrid(X,Y);
[m,n]=size(X);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CALCULATING THE VGEO

dPdY = diff(DYN,1,1)./DY;
dPdX = diff(DYN,1,2)./DX;


dPDX = interp2(X,Ygrad',dPdY,X,Y');
dPDY = interp2(Xgrad,Y',dPdX,X,Y');














