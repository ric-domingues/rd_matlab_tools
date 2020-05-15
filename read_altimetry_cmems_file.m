function [sha,adt,u,v,lon,lat] = read_altimetry_cmems_file(ncfile)

%  function [sha,adt,u,v,lon,lat] = read_altimetry_cmems_file(ncfile)
sha=nan;adt=nan;u=nan;v=nan;lon=nan;lat=nan;
scale_factor = 0.0001;
nc=netcdf(ncfile);

lon=nc{'longitude'}(:);
lat=nc{'latitude'}(:);

lon(lon>180) = lon(lon>180)-360;
[lon,ilon] = sort(lon);


sha=nc{'sla'}(:)*scale_factor;
sha(sha<-1e3) = nan;
sha=sha(:,ilon);

adt=nc{'adt'}(:)*scale_factor;
adt(adt<-1e3) = nan;
adt=adt(:,ilon);

u=nc{'ugos'}(:)*scale_factor;
u(u<-1e3) = nan;
u=u(:,ilon);

v=nc{'vgos'}(:)*scale_factor;
v(v<-1e3) = nan;
v=v(:,ilon);

