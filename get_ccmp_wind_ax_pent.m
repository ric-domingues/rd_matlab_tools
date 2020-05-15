function get_ccmp_wind_ax_pent(area,startdate,enddate,winddir,tempdir,outdir);

%  function get_ccmp_wind_ax_pent(area,startdate,enddate,winddir,tempdir,outdir);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%	This function reads ccmp Wind data and retrieve for the desired region
%  
%  		LON_lim = [area(1) area(2)];
%  		LAT_lim = [area(3) area(4)];
%  
%  
%
%		Ricardo M. Domingues AOML/NOAA, September 20, 2011
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
y0=floor(startdate/10000);

dir_yrs = dir([winddir,'/*']);
ii=0;
for l=1:length(dir_yrs)
	yr=str2num(dir_yrs(l).name);
	if(isempty(yr)),yr=0;end
	if(dir_yrs(l).isdir==1 && yr>=y0);ii=ii+1;
		I_KEEP(ii)=l;
	end
end

dir_yrs=dir_yrs(I_KEEP);

LON_lim = [area(1) area(2)];
LAT_lim = [area(3) area(4)];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cc = 0;
for y = 1:length(dir_yrs);
	
	dir_mth = dir([winddir,'/',dir_yrs(y).name,'/*'])

	for m=1:length(dir_mth)

		files = dir([winddir,'/',dir_yrs(y).name,'/',dir_mth(m).name,'/penta*gz']);

		for f=1:length(files)
			cc=cc+1;		
		
			filegz=[winddir,'/',dir_yrs(y).name,'/',dir_mth(m).name,'/',files(f).name];
			file=[tempdir,'/',files(f).name(1:end-3)]

			gunzip(filegz,tempdir);
			
			ncload(file)
			delete(file)

			lon(lon>180)=lon(lon>180)-360;
			ilon = find(lon>= LON_lim(1) & lon<= LON_lim(2));
			ilat = find(lat>= LAT_lim(1) & lat<= LAT_lim(2));											 
	
			lonS = lon(ilon);
			latS = lat(ilat);

			Uwnd=replace(uwnd(ilat,ilon),-32767,NaN).*0.00152597203850746;
           		Vwnd=replace(vwnd(ilat,ilon),-32767,NaN).*0.00152597203850746;
           		Wspd=replace(wspd(ilat,ilon),-32767,NaN).*0.0011444790288806+37.5;
%             		Upstr=replace(upstr(ilat,ilon),-32767,NaN).*0.0305194407701492;
%             		Vpstr=replace(vpstr(ilat,ilon),-32767,NaN).*0.0305194407701492;
           		Nobs=replace(nobs(ilat,ilon),-32767,NaN)+32766;

			[lonS,I]=sort(lonS);

			Uwnd=Uwnd(:,I);
			Vwnd=Vwnd(:,I);
           		Wspd=Wspd(:,I);
%             		Upstr=Upstr(:,I);
%             		Vpstr=Vpstr(:,I);
           		Nobs=Nobs(:,I);

			if(cc==1),
		
				[lon,lat]=meshgrid(lonS,latS);
				Zbathy = get_bathy2grid(lon,lat);
				Cont = find(Zbathy>=0);
			
				[mm,nn]=size(lon);

				for i=1:mm
					for j=1:nn
						lonDX(i,j) = sw_dist([lat(i,j) lat(i,j)],[lon(i,j) 0],'km')*(lon(i,j)/abs(lon(i,j)));
						latDX(i,j) = sw_dist([lat(i,j) 0],[lon(i,j) lon(i,j)],'km')*(lat(i,j)/abs(lat(i,j)));
					end

				end

			end
%  			imagesc(lonDX)
%  			pause		
%  			return

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
			mask = isnan(Taux);
			Taux_aux = inpaint_nans(Taux,5);
			Tauy_aux = inpaint_nans(Tauy,5);
			
			for s=1:10
				Taux_aux = smo(Taux_aux);
				Tauy_aux = smo(Tauy_aux);
			end

			Taux_aux(mask)=nan;
			Tauy_aux(mask)=nan;

			[curlz,cav] = curl(lonDX,latDX,Taux_aux,Tauy_aux);
			curlz_wgaps = curlz; % unit is N/(m2.km)
			curlz = inpaint_nans(curlz,5);
			curlz(Cont)=nan;
%  			pcolor(lonS,latS,curlz), shading flat; colorbar,caxis([-.0003 .0003])
%  			pause
%  			return
%  
%  			pcolor(lonS,latS,Wspd),shading flat
%  			STOP
			
			KK = find(files(f).name=='_');
			fileOUT = [outdir,'/',files(f).name(KK(1)+1:KK(2)-1),'_wind']
			
			lon=lonS;
			lat=latS;
			save(fileOUT,'lat','lon','Uwnd','Vwnd','Wspd','Nobs','Taux','Tauy','curlz','curlz_wgaps');
%  			save(fileOUT,'lat','lon','Uwnd','Vwnd','Wspd','Upstr','Vpstr','Nobs');
	
		end

	end

end

