function str2gmt(STR,IND_M,APND,FILEOUT);
%  function str2gmt(STR,IND_M,APND,FILEOUT);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	This function output strings from matlab to ascii file that can append on data output files
%  	
%  		STR -> string for output
%  		VAR - 2D matrix
%  		APND - 0 (opens new file), 1 (append to old file)
%  		IND_M - indice for tracking maps if outputing more than one map per file
%  		FILEOUT - output file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[MM,NN] = size(STR);

if(~isempty(IND_M))
	IND_OUT = IND_M*ones(MM,1);
	FMT = '%d\t %s\n';
	OUT = [IND_OUT,STR];
else
	FMT = '%s\n';
	OUT = [STR];
end	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if(APND)
	fid = fopen(FILEOUT,'a');
else
	fid = fopen(FILEOUT,'w');
end
fprintf(fid,FMT,OUT');
fclose(fid);








