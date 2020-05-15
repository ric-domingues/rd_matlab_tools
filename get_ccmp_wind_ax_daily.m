function get_ccmp_wind_ax_daily(area,startdate,enddate,winddir,tempdir,outdir);

%  function get_ccmp_wind_ax(area,startdate,enddate,winddir,tempdir,outdir);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%	This function reads ccmp Wind data and retrieve for the desired region
%
%		Ricardo M. Domingues AOML/NOAA, September 20, 2011
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

s = num2str(startdate);
e = num2str(enddate);

STARTDATE = julian(str2num(s(1:4)),str2num(s(5:6)),str2num(s(7:8)),0);
ENDDATE = julian(str2num(e(1:4)),str2num(e(5:6)),str2num(e(7:8)),0); 

LON_lim = [area(1) area(2)];
LAT_lim = [area(3) area(4)];


%  SCALE_FACTOR=0.00152597203850746;
SCALE_FACTOR=0.003051944;

clear startdate enddate s e area
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
files = dir([winddir,'/analysis*nc']);

count=0;
for f=1:length(files)
			
%  	filegz=[winddir,'/',files(f).name];
%  	file=[tempdir,'/',files(f).name(1:end-3)];
	file=[winddir,'/',files(f).name];

	fl = files(f).name;
	YYYY = str2num(fl(10:13));
	MM = str2num(fl(14:15));
	DD = str2num(fl(16:17));
	
	fileDATE = julian(YYYY,MM,DD,0);

	if(fileDATE >=STARTDATE & fileDATE <=ENDDATE)
		count=count+1;

%  		gunzip(filegz,tempdir);
		
		ncload(file)
%  		delete(file)
		
		if(count==1)
			lon(lon>180)=lon(lon>180)-360;			
			ilon = find(lon>= LON_lim(1) & lon<= LON_lim(2));
			ilat = find(lat>= LAT_lim(1) & lat<= LAT_lim(2));											 					
			lonS = lon(ilon);
			latS = lat(ilat);
			[lonS,I]=sort(lonS);
		end

		for t=1:4
			HR= 0 + (t-1)*6;

			fileOUT = [outdir,'/',sprintf('%04g%02g%02g_%02gZ_ccmp',YYYY,MM,DD,HR)]
	
			Uwnd=squeeze(replace(uwnd(t,ilat,ilon),-32767,NaN).*SCALE_FACTOR);
			Vwnd=squeeze(replace(vwnd(t,ilat,ilon),-32767,NaN).*SCALE_FACTOR);
			Nobs=squeeze(replace(nobs(t,ilat,ilon),-32767,NaN)+32766);

			Uwnd=Uwnd(:,I);
			Vwnd=Vwnd(:,I);
			Nobs=Nobs(:,I);

			%----------------------------- Calculating wind stress based on th bulk formula

			Wspd = sqrt(Uwnd.^2 + Vwnd.^2);
			Upstr = Uwnd.*Wspd;
			Vpstr = Vwnd.*Wspd;		

			Rho_ar = 1; %kg/m3
			Rho_oc = 1000;
			Cd = 7.5e-4 + 6.5e-5.*Wspd; % Following Garrat et al 1977
			Taux = Rho_ar.*Cd.*Upstr; % Following Pedlosky 1987 (N/m2)
			Tauy = Rho_ar.*Cd.*Vpstr; % Following Pedlosky 1987 (N/m2)
			%----------------------------- Calculating wind stress based on th bulk formula
			
			lon=lonS;
			lat=latS;
		
			save(fileOUT,'lat','lon','Uwnd','Vwnd','Wspd','Nobs','Taux','Tauy');

		end

	end 
	
end

