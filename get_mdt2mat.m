function [ret]=get_mdt2mat(mdt_file,WORKDIR,AREA)
%  function [ret]=get_mdt2mat(mdt_file,WORKDIR,AREA)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	This function reads the MDT climatology and saves into mat format
%  
%  		Ricardo Domingues, AOML/NOAA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ret.code = 0;
try
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp(['AREA = ',AREA])
K=find(AREA=='/');
LON_LIM = [str2num(AREA(1:K(1)-1)) str2num(AREA(K(1)+1:K(2)-1))];
LAT_LIM = [str2num(AREA(K(2)+1:K(3)-1)) str2num(AREA(K(3)+1:end))];

lon_ref=LON_LIM(1):.3:LON_LIM(2);
lat_ref=LAT_LIM(1):.3:LAT_LIM(2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


nc=netcdf(mdt_file);
mdt=nc{'Grid_0001'}(:,:)';
U =nc{'Grid_0002'}(:,:)';
V =nc{'Grid_0003'}(:,:)';

lon_mdt=nc{'NbLongitudes'}(:,:);
lon_mdt(lon_mdt>180) = lon_mdt(lon_mdt>180) - 360; 
lat_mdt=nc{'NbLatitudes'}(:,:);
[lon_mdt,I]=sort(lon_mdt);
mdt = mdt(:,I);
U = U(:,I);
V = V(:,I);

mask=find(mdt>100);
mdt(mask)=nan;
U(mask)=nan;
V(mask)=nan;
Vel = sqrt(U.^2 + V.^2);

[lon_mdt,lat_mdt]=meshgrid(lon_mdt,lat_mdt);

mdt = interp2(lon_mdt,lat_mdt,mdt,lon_ref,lat_ref');
uc = interp2(lon_mdt,lat_mdt,U,lon_ref,lat_ref');
vc = interp2(lon_mdt,lat_mdt,V,lon_ref,lat_ref');

save([WORKDIR,'/MDT_matfile'],'mdt','uc','vc')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
catch

	[ err_msg ] = get_err_msg;

	ret.code = -1;
        ret.msg = err_msg;

end 