function [ret]=get_sstd1_2mat_SUBSET(WORKDIR,OUTDIR,AREA)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	This function reads formated xyz.dat TCHPdata and converts into a grid MAT file
%  
%  		Ricardo Domingues, AOML/NOAA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ret.code = 0;
try
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
LON_LIM = [AREA(1) AREA(2)];
LAT_LIM = [AREA(3) AREA(4)];

LON_ref = LON_LIM(1):.25:LON_LIM(2);
LAT_ref = LAT_LIM(1):.25:LAT_LIM(2);

[lon_ref,lat_ref]=meshgrid(LON_ref,LAT_ref);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
files_dt=dir([OUTDIR,'/*sstd1.mat']);

time_DT=[];

for i=1:length(files_dt);
  [yr,mm,dd,JUL] = filename2dates(files_dt(i).name);
  time_DT(i) = JUL;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


	files=dir([WORKDIR,'/*.gz']);

	for f=1:length(files)

		DATE=files(f).name(1:end-7);
		[yr,mm,dd,JUL] = filename2dates(DATE);
		KJUL = find(time_DT==JUL);
		
		if(isempty(KJUL))

		    CMD = ['!cp ',WORKDIR,'/',files(f).name,' ./buf.gz'];
		    eval(CMD)
		    
		    CMD = ['!gunzip buf.gz'];
		    eval(CMD);

		    CMD = ['!xyz2grd buf -Gt.grd -I.26/.26 -R-180/180/-90/90'];
		    
		    eval(CMD);
		    
		    ncload t.grd
	      
		    sst = interp2(x,y,z,lon_ref,lat_ref);
		    
%  %  %  		    imagesc(sst), pause(10), return

		    !rm buf* t.grd

		    
		    
    %  %  		pcolor(lon_ref,lat_ref,sst),shading flat, pause	
    %  %  		return
		    fileout=[OUTDIR,'/',DATE,'_sstd1'];
		    disp(fileout)		
		    save(fileout,'sst','lon_ref','lat_ref');
		end
	end
	
	save([OUTDIR,'/sst_lonlat'],'lon_ref','lat_ref');
%  	pcolor(lon_ref,lat_ref,t),shading flat, pause(2)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
catch

	[ err_msg ] = get_err_msg;

	ret.code = -1;
        ret.msg = err_msg

end 

