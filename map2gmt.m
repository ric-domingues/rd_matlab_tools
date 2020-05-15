function map2gmt(lon,lat,VAR,IND_M,APND,FILEOUT);
%  map2gmt(lon,lat,VAR,IND_M,FILEOUT);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	This function gets maps from matlab and saves in GMT ready formats   
%  	
%  		lon and lat - 2D matrix  
%  		VAR - 2D matrix
%  		APND - 0 (opens new file), 1 (append to old file)
%  		IND_M - indice for tracking maps if outputing more than one map per file
%  		FILEOUT - output file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[MM,NN] = size(lon);

X = reshape(lon,MM*NN,1);
Y = reshape(lat,MM*NN,1);
V = reshape(VAR,MM*NN,1);

if(~isempty(IND_M))
	IND_OUT = IND_M*ones(MM*NN,1);
	FMT = '%d\t %.6f\t %.6f\t %.6f\n';
	OUT = [IND_OUT,X,Y,V];
else
	FMT = '%.6f\t %.6f\t %.6f\n';
	OUT = [X,Y,V];
end	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if(APND)
	fid = fopen(FILEOUT,'a');
else
	fid = fopen(FILEOUT,'w');
end
fprintf(fid,FMT,OUT');
fclose(fid);








