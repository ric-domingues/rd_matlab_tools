function vectorSTR2gmt(XX,YY,IND_M,APND,FILEOUT);
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if(APND)
	fid = fopen(FILEOUT,'a');
else
	fid = fopen(FILEOUT,'w');
end

XX = XX'

if(~isempty(IND_M))
	IND_OUT = IND_M*ones(MM*NN,1);
	FMT = '%d\t %s\t %.6f\n';
	fprintf(fid,FMT,IND_OUT,XX,YY');	
else
	FMT = '%.6s\t %.6f\n';
	fprintf(fid,FMT,XX,YY);		
end	


fclose(fid);



