function curlZ = get_curlZ(lon,lat,U,V);

%  function curlZ = get_curlZ(lon,lat,U,V);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%	This function calculates the culrZ from an U and V field
%  	
%  		curlZ (units/m) 
%
%		Ricardo M. Domingues AOML/NOAA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[m,n]=size(lon);
m2=m*10;
n2=n*10;

lon1 = linspace(nanmin(lon(:)),nanmax(lon(:)),n2);
lat1 = linspace(nanmin(lat(:)),nanmax(lat(:)),m2);

[lon2,lat2]=meshgrid(lon1,lat1);

CMASK = isnan(U);
U = inpaint_nans(U,5);
V = inpaint_nans(V,5);

U2 = interp2(lon,lat,U,lon2,lat2);
V2 = interp2(lon,lat,V,lon2,lat2);

U2 = smoothn(U2,15);
V2 = smoothn(V2,15);

%  refLON = nanmin(lon1);
%  refLAT = nanmin(lat1); 

refLON = nanmean(lon1);
refLAT = nanmean(lat1);

for i=1:n
	SIGN = (lon(1,i) - refLON)./abs(lon(1,i) - refLON);
	lonDX(i) = sw_dist([refLAT refLAT],[lon(1,i) refLON],'km')*1e3*SIGN;
end

for i=1:m
	SIGN = (lat(i,1) - refLAT)./abs(lat(i,1) - refLAT);
	latDX(i) = sw_dist([lat(i,1) refLAT],[refLON refLON],'km')*1e3*SIGN;
end

latDX2 = linspace(nanmin(latDX),nanmax(latDX),m2);
lonDX2 = linspace(nanmin(lonDX),nanmax(lonDX),n2);

[lonDX2,latDX2]=meshgrid(lonDX2,latDX2);

[curlZ2,cav] = curl(lonDX2,latDX2,U2,V2);

curlZ = interp2(lon2,lat2,curlZ2,lon,lat);
curlZ(CMASK) = nan;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
