%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ret = subset_JPL_SMAP_SSS(satsaltdir,outdir,AREA)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ret.code=0;
try
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

files_nc=dir([satsaltdir,'/*nc']);
files_mat=dir([outdir,'/*mat']);

for f=1:length(files_mat)
	[yyyy,mm,dd,time_MATFILES(f)] = filename2dates(files_mat(f).name);
end

c=0;
for f=1:length(files_nc)

	[yyyy,mm,dd,JUL_NC] = filename2dates(files_nc(f).name(13:20));

	Kfile = find(time_MATFILES==JUL_NC);

	if(isempty(Kfile))		
		c=c+1;
		files_use(c)=files_nc(f);
	end
end

if(~exist('files_use'))
	return
end

files_nc = files_use;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

LON_LIM = [AREA(1) AREA(2)];
LAT_LIM = [AREA(3) AREA(4)];
%-------------------------------------------------------------------------------------------------

lon_satsalt = ncread([satsaltdir,'/',files_nc(end).name],'longitude');
lat_satsalt = ncread([satsaltdir,'/',files_nc(end).name],'latitude');

Ilat = find(lat_satsalt>=LAT_LIM(1) & lat_satsalt<=LAT_LIM(2));
Ilon = find(lon_satsalt>=LON_LIM(1) & lon_satsalt<=LON_LIM(2));

lat_satsalt = lat_satsalt(Ilat);
lon_satsalt = lon_satsalt(Ilon);

[lon2,lat2] = meshgrid(lon_satsalt,lat_satsalt);

[Zbathy]=get_bathy2grid(lon2,lat2,5);

%-------------------------------------------------------------------------------------------------

 for f=1:length(files_nc)

	satsalt = ncread([satsaltdir,'/',files_nc(f).name],'smap_sss');
	satsalt = satsalt';
	satsalt = satsalt(Ilat,Ilon);
	K=find(satsalt<-1e3);
    satsalt(K)=nan;
    satsalt_smo = satsalt;
    satsalt_smo(Zbathy>-10)=nan;
    satsalt_smo = inpaint_nans(satsalt_smo,5);
	satsalt_smo = smoothn(satsalt_smo,1);

	sst = ncread([satsaltdir,'/',files_nc(f).name],'anc_sst');
	sst = sst';
	sst = sst(Ilat,Ilon)-273.15;% Celcius	
	sst(K) = nan;
    sst_smo = sst;
    sst_smo(Zbathy>-10)=nan;
    sst_smo = inpaint_nans(sst_smo,5);
	sst_smo = smoothn(sst_smo,1);

	time_sec = ncread([satsaltdir,'/',files_nc(f).name],'time');
	time_JUL = julian(2015,1,1,0) + time_sec./(24*60*60);
	date_out = num2str(time_jul2YY(time_JUL));

	fileout = [outdir,'/',date_out,'_satsalt']

	save(fileout,'lon_satsalt','lat_satsalt','satsalt','sst','time_JUL','sst_smo','satsalt_smo')


end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
catch

	[ err_msg ] = get_err_msg

	ret.code = -1
        ret.msg = err_msg

end
