function [ret]=get_sstd1_2mat(WORKDIR,OUTDIR)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	This function reads formated xyz.dat TCHPdata and converts into a grid MAT file
%  
%  		Ricardo Domingues, AOML/NOAA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ret.code = 0;
try
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

RES=.33;

	files=dir([WORKDIR,'/*.gz']);

	for f=1:length(files)

		DATE=files(f).name(1:end-7);
		disp(DATE)

		CMD = ['!cp ',WORKDIR,'/',files(f).name,' ./buf.gz'];
		eval(CMD)
		
		CMD = ['!gunzip buf.gz'];
		eval(CMD);

		CMD = ['!xyz2grd buf -Gt.grd -I.33/.33 -R-180/180/-90/90'];
		eval(CMD);
		
		ncload t.grd

		sst=z;
		lon_ref=x;
		lat_ref=y;

		!rm buf* t.grd

%  %  %  		pcolor(lon_ref,lat_ref,sst),shading flat, pause	
	
		save([OUTDIR,'/sstd1_',DATE],'sst');
		
	end
	
	save([OUTDIR,'/sst_lonlat'],'lon_ref','lat_ref');
%  	pcolor(lon_ref,lat_ref,t),shading flat, pause(2)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
catch

	[ err_msg ] = get_err_msg;

	ret.code = -1;
        ret.msg = err_msg;

end 

