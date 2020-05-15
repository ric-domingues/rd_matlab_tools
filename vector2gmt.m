function vector2gmt(XX,YY,IND_M,APND,FILEOUT);
%  function vector2gmt(XX,YY,IND_M,APND,FILEOUT);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	This function gets maps from matlab and saves in GMT ready formats   
%  	
%  		XX and YY - 1D matrix  
%  		APND - 0 (opens new file), 1 (append to old file)
%  		IND_M - indice for tracking maps if outputing more than one map per file
%  		FILEOUT - output file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[MM,NN] = size(XX);

X = reshape(XX,MM*NN,1);
Y = reshape(YY,MM*NN,1);

if(~isempty(IND_M))
	IND_OUT = IND_M*ones(MM*NN,1);
	FMT = '%d\t %.6f\t %.6f\n';
	OUT = [IND_OUT,X,Y];
else
	FMT = '%.6f\t %.6f\n';
	OUT = [X,Y];
end	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if(APND)
	fid = fopen(FILEOUT,'a');
else
	fid = fopen(FILEOUT,'w');
end
fprintf(fid,FMT,OUT');
fclose(fid);








