function TSv = integrate_transpSEC(lon,lat,z,Vel);

%  function TSv = integrate_transpSEC(lon,lat,z,Vel);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  	This function integrates the cross-section transport provided the velocity field
%  
%  			lon - 1D vector
%  			lat - 1D vector
%  			z - 1D vector
%  
%  			Vel - 2D matrix  
%
%  			Ricardo Domingues, AOML/NOAA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
TSv=NaN;

z=abs(z);

DX = sw_dist(lat,lon,'km')*1e3;
X_ref = [0,cumsum(DX)];
X_grad = X_ref(1:end-1) + diff(X_ref)/2;
Z_grad = z(1:end-1) + diff(z)/2;

[X_grad,Z_grad] = meshgrid(X_grad,Z_grad);
Vel2 = interp2(X_ref,z,Vel,X_grad,Z_grad);

[m,n] = size(DX);
DX = reshape(DX,1,m*n);
DZ = diff(z);
[m,n] = size(DZ);
DZ = reshape(DZ,m*n,1);
AREA = DZ*DX;

%  imagesc(AREA)

T2 = AREA.*Vel2;
TSv = nansum(T2(:))/1e6;









