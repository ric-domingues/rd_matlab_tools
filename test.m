clc;clear all;close all






















return


lon = -180:180;
lat = -90:90;

[lon,lat]=meshgrid(lon,lat);
%  
%  [m,n]=size(lon);
%  
%  
%  OUT = [reshape(lon,1,m*n);reshape(lat,1,m*n)];
%  
%  FMT = '%.2f %.2f\n';
%  
%  
%  fid=fopen('coor_tst.dat','w');
%  fprintf(fid,FMT,OUT);
%  fclose(fid)



[m,n]=size(lon);

for i=1:m

	for j=1:n
		
	lonDX(i,j) = sw_dist([lat(i,j) lat(i,j)],[lon(i,j) 0],'km')*(lon(i,j)/abs(lon(i,j)));
	latDX(i,j) = sw_dist([lat(i,j) 0],[lon(i,j) lon(i,j)],'km')*(lat(i,j)/abs(lat(i,j)));

	end

end

imagesc(lonDX)