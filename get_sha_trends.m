function [SHA_TREND,lon_out,lat_out,SHA_SIG] = get_sha_trends(shadir,AREA, STARTDATE,ENDDATE,FILT);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%	This function retrieves the SHA time-series for P1 and P2
%
%		Ricardo M. Domingues AOML/NOAA
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
SHA_TREND=nan;
lon_ref=nan;
lat_ref=nan;
SIG=nan;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%	
jul_start = julian(STARTDATE);
jul_end = julian(ENDDATE);

LON_LIM = [AREA(1:2)];
LAT_LIM = [AREA(3:4)];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Generating the altimetry reference time
files = dir([shadir,'/*sha*mat']);

for f=1:length(files)
	file=files(f).name;
	yyyy=str2num(file(1:4));
	mm=str2num(file(5:6));
	dd=str2num(file(7:8));
	time_ref(f) = julian(yyyy,mm,dd,0);
		
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load([shadir,'/',files(1).name])

IND_lon = find(lon_ref(1,:)>=LON_LIM(1) & lon_ref(1,:)<=LON_LIM(2));
IND_lat = find(lat_ref(:,1)>=LAT_LIM(1) & lat_ref(:,1)<=LAT_LIM(2));

sha_RES = sha_RES(IND_lat,IND_lon);
lon_use = lon_ref(IND_lat,IND_lon);
lat_use = lat_ref(IND_lat,IND_lon);
MASK = isnan(sha_RES);

%  pcolor(lon_use,lat_use,sha_RES), shading flat

Trend_all = nan(size(lon_use));
SIG_all = zeros(size(lon_use));

KTIME = find(time_ref>=jul_start & time_ref<=jul_end);
time_USE = time_ref(KTIME);

time_GMT = time_jul2GMT(time_USE);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[m,n] = size(lon_use);

%  Klat = find(lat_use(:,1)>=27);Klat=Klat(1);
%  Klon = find(lon_use(1,:)>=-79.5);Klon=Klon(1);
%  %  [lon_use(Klat,Klon) lat_use(Klat,Klon)]


for i=1:m
%  for i=Klat
  i
	SHA_lat = nan(length(KTIME),n);
	
	c=0;
	for f = KTIME
		c=c+1;
%  		[i f c]
		file = files(f).name;
		load([shadir,'/',file]);			
		sha_RES = sha_RES(IND_lat,IND_lon);		
		
		SHA_lat(c,:) = sha_RES(i,:);
	end
	
	for j=1:n
%  %  	for j=Klon	
		if(MASK(i,j)==0);
%  			disp('Here is')
			t_aux = SHA_lat(:,j);
			
%  			[lat_use(i,j) lon_use(i,j)]
			
			if(FILT>0);t_aux = rmean(t_aux,FILT);end 
			%------------------------------------ ALL period
%  			plot(time_GMT,t_aux), hold on
			[V,SIG,ERR,X,Y]=get_trend(time_GMT,t_aux,0.05,0); % degC/year
%  %  			pause,return			
			
			Trend_all(i,j) = V*10;%mm/year
			SIG_all(i,j) = SIG;
		end
	end


end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Saving 
SHA_TREND=Trend_all;
lon_out = lon_use; 
lat_out = lat_use;
SHA_SIG= SIG_all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
