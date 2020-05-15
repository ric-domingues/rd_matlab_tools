function [ ret ] = get_sha_tseries(shadir,points_file,outfile);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%	This function retrieves the SHA time-series for P1 and P2
%
%		Ricardo M. Domingues AOML/NOAA
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ret.code=0;

try
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%	

load(points_file);
Npoints=length(whos('P*'));

for n=1:Npoints

	CMD=['lat_p = P',num2str(n),'.lat;']; eval(CMD);
	CMD=['lon_p = P',num2str(n),'.lon;']; eval(CMD);

	lat_ALL(n) = lat_p;
	lon_ALL(n) = lon_p;
end  

LAT_LIM = [nanmin(lat_ALL)-3 nanmax(lat_ALL)+3];
LON_LIM = [nanmin(lon_ALL)-3 nanmax(lon_ALL)+3];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Generating the altimetry reference time
files = dir([shadir,'/*qd*nc']);

for f=1:length(files)
	file=files(f).name;
	
	if(f==1);
		IND_n=find(file=='_');			
	end
	DATE = file(IND_n(7)+1:IND_n(8)-1);

	yyyy=str2num(DATE(1:4));
	mm=str2num(DATE(5:6));
	dd=str2num(DATE(7:8));

	time_ref(f) = julian(yyyy,mm,dd,0);
		
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Information about the grid

file=files(1).name;
nc=netcdf([shadir,'/',file]);
lon=nc{'NbLongitudes'}(:);
lat=nc{'NbLatitudes'}(:);

K=find(lon>180);
lon(K)=lon(K)-360;

IND_lon = find(lon>=LON_LIM(1) & lon<=LON_LIM(2));
IND_lat = find(lat>=LAT_LIM(1) & lat<=LAT_LIM(2));

lon=lon(IND_lon);
lat=lat(IND_lat);
[lon,I]=sort(lon);

[lon2,lat2]=meshgrid(lon,lat);

[m,n]=size(lon2);

ssha = nc{'Grid_0001'}(IND_lon,IND_lat)';
MASK=find(ssha>1e3);
ssha(MASK)=nan;
MASK=isnan(ssha);

close(nc)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Retrieving the time-series and calculating the correlations

for f=1:length(files)

	file=files(f).name;
	nc=netcdf([shadir,'/',file]);	
	ssha = nc{'Grid_0001'}(IND_lon,IND_lat)';
	close(nc)
	ssha(MASK)=nan;	
	ssha=ssha(:,I);

	for n=1:Npoints	
		CMD=['lat_p = P',num2str(n),'.lat;']; eval(CMD);
		CMD=['lon_p = P',num2str(n),'.lon;']; eval(CMD);
		
		sha = interp2(lon2,lat2,ssha,lon_p,lat_p);
		CMD=['P',num2str(n),'.sha(f)=sha;']; eval(CMD);
	end	

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Saving 

for n=1:Npoints
	CMD=['P',num2str(n),'.time=time_ref;']; eval(CMD);
end

SAVE_CMD = ['save ',outfile,' P*'];eval(SAVE_CMD);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
catch

	[ err_msg ] = get_err_msg;

	ret.code = -1;
        ret.msg = err_msg;

end 



