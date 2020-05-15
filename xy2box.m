function ret=xy2box(filein,fileout,box_res,AREA,box_use);

%  function xy2box(filein,fileout,box_res);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  	This function computes the boxed statistics from xy data
%	  
%  		Ricardo Domingues, AOML/NOAA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ret.code = 0;
try
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
K=find(AREA=='/');
LON_LIM = [str2num(AREA(1:K(1)-1)) str2num(AREA(K(1)+1:K(2)-1))];
LAT_LIM = [str2num(AREA(K(2)+1:K(3)-1)) str2num(AREA(K(3)+1:end))];

K=find(box_res=='x');
DX=str2num(box_res(1:K-1));
DY=str2num(box_res(K+1:end));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

lon_box = LON_LIM(1)+DX/2:DX:LON_LIM(2)-DX/2;
lat_box = LAT_LIM(1)+DY/2:DY:LAT_LIM(2)-DY/2;

[lon_box2,lat_box2]=meshgrid(lon_box,lat_box);
[n,m]=size(lon_box2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if(~exist('box_use'))
	box_use = box_res;
end
	
K=find(box_use=='x');
DX=str2num(box_use(1:K-1));
DY=str2num(box_use(K+1:end));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[lon,lat,v]=textread(filein,'%f %f %f');
MEAN_box = nan(n,m);
STD_box = nan(n,m);
COUNT_box = zeros(n,m);

for i=1:n

	for j=1:m
	
		IND = find(lat>=lat_box(i)-DY/2 & lat<lat_box(i)+DY/2 & lon>=lon_box(j)-DX/2 & lon<lon_box(j)+DX/2);

		COUNT_box(i,j) = length(IND);
		MEAN_box(i,j) = nanmean(v(IND));
		STD_box(i,j) = nanstd(v(IND));
	
	end

end 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
K=find(COUNT_box>0);

FMT = '%.3f %.3f %.3f %.3f %.1f\n';

FOUT = [lon_box2(K),lat_box2(K),MEAN_box(K),STD_box(K),COUNT_box(K)];

fid=fopen(fileout,'w');
fprintf(fid,FMT,FOUT');
fclose(fid);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
catch

	[ err_msg ] = get_err_msg;

	ret.code = -1;
        ret.msg = err_msg;

end 
