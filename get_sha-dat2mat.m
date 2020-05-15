function [ret]=get_sha2mat(WORKDIR,AREA)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	This function reads formated xyz.dat SHA data and converts into a grid MAT file
%  
%  		Ricardo Domingues, AOML/NOAA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ret.code = 0;
try
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	disp(['AREA = ',AREA])
	K=find(AREA=='/');
	LON_LIM = [str2num(AREA(1:K(1)-1)) str2num(AREA(K(1)+1:K(2)-1))];
	LAT_LIM = [str2num(AREA(K(2)+1:K(3)-1)) str2num(AREA(K(3)+1:end))];

	lon_ref=LON_LIM(1):.3:LON_LIM(2);
	lat_ref=LAT_LIM(1):.3:LAT_LIM(2);

	files=dir([WORKDIR,'/*sha*dat']);
	
	for f=1:length(files)

		file=files(f).name;
		disp(file)				
		MT=load([WORKDIR,'/',file]);

		lon0=MT(:,1);
		lat0=MT(:,2);
		t=MT(:,3);

		bin = bin2d(lon0,lat0,t,lon_ref,lat_ref);

		t = bin.mean./100;%m
		
		save([WORKDIR,'/',file(1:end-4)],'t');

	end
	
	save([WORKDIR,'/Reference_lonlat'],'lon_ref','lat_ref');
%  	pcolor(lon_ref,lat_ref,t),shading flat, pause(2)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
catch

	[ err_msg ] = get_err_msg;

	ret.code = -1;
        ret.msg = err_msg;

end 





