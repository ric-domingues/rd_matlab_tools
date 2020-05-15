function [ ret ] = get_oisst2mat(datadir,outdir,STARTDATE,ENDDATE,AREA,DT);

%  [ ret ] = get_oisst2mat(datadir,outdir,STARTDATE,ENDDATE,AREA,DT);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	This function retrieves the OISST data for an specific AREA and time frame  
%  		and stores it into mat files
%  
%  			Ricardo Doingues, AOML/NOAA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ret.code=0;

try
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

files=dir([datadir,'/*nc']);

disp(['AREA = ',AREA])
K=find(AREA=='/');
LON_LIM = [str2num(AREA(1:K(1)-1)) str2num(AREA(K(1)+1:K(2)-1))];
LAT_LIM = [str2num(AREA(K(2)+1:K(3)-1)) str2num(AREA(K(3)+1:end))];

lon_ref=LON_LIM(1):.3:LON_LIM(2);
lat_ref=LAT_LIM(1):.3:LAT_LIM(2);

[lon2,lat2]=meshgrid(lon_ref,lat_ref);

%======================================= DATES ===================================
yyyy1 = str2num(STARTDATE(1:4));
mm1 = str2num(STARTDATE(5:6));
dd1 = str2num(STARTDATE(7:8));

yyyy2 = str2num(ENDDATE(1:4));
mm2 = str2num(ENDDATE(5:6));
dd2 = str2num(ENDDATE(7:8));


START=julian(yyyy1,mm1,dd1,0);
END=julian(yyyy2,mm2,dd2,0);
%======================================= DATES ===================================

save([outdir,'/Reference_lonlat'],'lon_ref','lat_ref');

YRS=yyyy1:yyyy2;
time_ref = julian(yyyy1,mm1,dd1,0):DT:julian(yyyy2,mm2,dd2,0);

c=1;
resp=0
for y=YRS;

	y
	nc = netcdf([datadir,'/sst.day.mean.',num2str(y),'.v2.nc']);
	time = nc{'time'}(:); 

	time_jul = time + julian(1800,1,1,0);

	if(c==1);
		lon = nc{'lon'}(:);
		lon(lon>180)=lon(lon>180)-360;
		IND_lon = find(lon>=LON_LIM(1) & lon<=LON_LIM(2));

		lat = nc{'lat'}(:);
		IND_lat = find(lat>=LAT_LIM(1) & lat<=LAT_LIM(2));
		
		lon=lon(IND_lon);
		[lon,I]=sort(lon);
		lat=lat(IND_lat);
	end
	
	while(time_ref(c)>=julian(y,1,1,0) & time_ref(c)<=julian(y,12,31,0) & resp==0);

		IND_time = find(time_jul==time_ref(c));
		if(y>=2010)		
		  sst = nc{'sst'}(IND_time,:,:);%./100;
		else
		  sst = nc{'sst'}(IND_time,:,:)./100;
		end

		sst = sst(IND_lat,IND_lon);
		sst=sst(:,I);

		K=find(sst>50);
		sst(K)=nan;
		t=interp2(lon,lat,sst,lon2,lat2);

		greg=gregorian(time_ref(c));
		
		fileout = [outdir,'/',sprintf('%04g%02g%02g',greg(1),greg(2),greg(3)),'_sst'];	
		
		save(fileout,'t');
	
		c=c+1;
		if(c>length(time_ref))
			c=c-1;
			resp=1;
		end
	end

end


	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
catch

	[ err_msg ] = get_err_msg;

	ret.code = -1;
        ret.msg = err_msg;

end 

