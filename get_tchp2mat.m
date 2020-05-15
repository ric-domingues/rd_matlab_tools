function [ret]=get_tchp2mat(TCHP_DIR_DT,TCHP_DIR_RT,AREA,OUTDIR)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	This function reads formated xyz.dat TCHPdata and converts into a grid MAT file
%  
%  		Ricardo Domingues, AOML/NOAA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ret.code = 0;
try
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

OUTDIR

TCHP_DIR_DT

TCHP_DIR_RT

RES=.25;
AREA='-180/180/-90/90';

	disp(['AREA = ',AREA])
	K=find(AREA=='/');
	LON_LIM = [str2num(AREA(1:K(1)-1)) str2num(AREA(K(1)+1:K(2)-1))];
	LAT_LIM = [str2num(AREA(K(2)+1:K(3)-1)) str2num(AREA(K(3)+1:end))];

	lon_ref=LON_LIM(1):RES:LON_LIM(2);
	lat_ref=LAT_LIM(1):RES:LAT_LIM(2);

	[lon_ref2,lat_ref2]=meshgrid(lon_ref,lat_ref);
	[m,n] = size(lon_ref2);
	files=dir([TCHP_DIR_DT,'/*.gz']);

	save([OUTDIR,'/tchp_lonlat'],'lon_ref','lat_ref','lon_ref2','lat_ref2');	
	
	for f=1:length(files)

		DATE=files(f).name(1:end-3);
		
		
		fileOUT = dir([OUTDIR,'/',DATE,'*DT*.mat']);
				
		if(isempty(fileOUT))	
		
		    disp(DATE)

		    disp(['   gunzipping file...'])		    
		    CMD = ['!rm -f buf buf.gz'];		    
		    eval(CMD);		

		    CMD = ['!cp ',TCHP_DIR_DT,'/',files(f).name,' ./buf.gz'];
		    eval(CMD)

		    CMD = ['!gunzip buf.gz'];
		    eval(CMD);

		    [lon0,lat0,t,h26]=textread('buf','%f %f %f %f');

		    tchp=nan(m,n);
		    D26=nan(m,n);	
		    for i=1:length(t)
			    
			    IND_LON = (lon0(i)-LON_LIM(1))./RES + 1;
    %  			lon0(i)
    %  			lon_ref(IND_LON)

			    IND_LAT = (lat0(i)-LAT_LIM(1))./RES + 1;
    %  			lat0(i)
    %  			lat_ref(IND_LAT)
			    tchp(IND_LAT,IND_LON) = t(i);
			    D26(IND_LAT,IND_LON) = h26(i);

		    end

		    !rm buf*
%  		    pcolor(lon_ref,lat_ref,tchp),shading flat, pause	
%  		    return
		    outfile = [OUTDIR,'/',DATE,'_tchp_DT']		    
		    save(outfile,'tchp','D26');
		    		
		end

	end	
	Last_DT=str2num(DATE);
	Last_DT=20180101

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%	
	
	files=dir([TCHP_DIR_RT,'/*.gz']);
	
	for f=1:length(files)

		DATE=files(f).name(1:end-3);

		
		fileOUT = dir([OUTDIR,'/',DATE,'*RT*.mat']);
		
		if(isempty(fileOUT) & str2num(DATE) > Last_DT)	
		
		    disp(DATE)
		    
		    disp(['   gunzipping file...'])		    
		    CMD = ['!rm -f buf buf.gz'];		    
		    eval(CMD);

		    CMD = ['!cp ',TCHP_DIR_RT,'/',files(f).name,' ./buf.gz'];
		    eval(CMD)

		    CMD = ['!gunzip buf.gz'];
		    eval(CMD);
		    [lon0,lat0,t,h26]=textread('buf','%f %f %f %f');

		    tchp=nan(m,n);
		    D26=nan(m,n);	
		    for i=1:length(t)
			    
			    IND_LON = (lon0(i)-LON_LIM(1))./RES + 1;
    %  			lon0(i)
    %  			lon_ref(IND_LON)

			    IND_LAT = (lat0(i)-LAT_LIM(1))./RES + 1;
    %  			lat0(i)
    %  			lat_ref(IND_LAT)
			    tchp(IND_LAT,IND_LON) = t(i);
			    D26(IND_LAT,IND_LON) = h26(i);

		    end

		    !rm buf*
%  		    pcolor(lon_ref,lat_ref,tchp),shading flat, pause	
%  		    return
		    outfile = [OUTDIR,'/',DATE,'_tchp_RT']		    
		    save(outfile,'tchp','D26');
		    		
		end

	end
	
	
	
	
	

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
catch

	[ err_msg ] = get_err_msg

	ret.code = -1;
        ret.msg = err_msg;

end 

