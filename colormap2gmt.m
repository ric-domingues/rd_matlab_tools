function [ret]=colormap2gmt(CMAP_USE,GMT_RANGE,FILEOUT);

%  function colormap2gmt(CMAP_USE,GMT_RANGE,FILEOUT);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	This function writes gmt cpt files using colormaps from matlab
%  
%  		CMAP_USE => matlab colormap to use (structure, e.g CMAP_USE = {'jet'};)
%  		GMT_RANGE => cpt configuration [min max spacing];
%		CPT_FILE => output GMT cpt file (e.g testmat2cpt.cpt);
%  
%		USAGE-1: Default matlab colormaps   
% 	
%		  	>> colormap2gmt({'jet'},[0 10 0.5],'testmat2cpt.cpt'); 
%  			% will output the cpt file "testmat2cpt.cpt" using the 
%  			% jet colormap for the data range between 0 and 10, spacing of 0.5 
%  			
%		USAGE-2: Custom colormaps   
% 	
%		  	>> colormap2gmt({'load' 'blackjet2wht'},[0 10 0.5],'testmat2cpt.cpt'); 
%  			% will output the cpt file "testmat2cpt.cpt" using the custom colormap  
%  			% blackjet2wht colormap for the data range between 0 and 10, spacing of 0.5
%  
%  			NOTE: file blackjet2wht.mat contains the colormap store in the variable cmap, and
%  				is on the same directory, or on a know matlab path.		   
%  
%		Ricardo Domingues, AOML/NOAA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ret.code=0;
try
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if(length(CMAP_USE)==1)
CMD = ['CMAP = ',CMAP_USE{1},';'];
eval(CMD), close all
else
load(CMAP_USE{2})
CMAP = cmap;
end

range_ref = GMT_RANGE(1):GMT_RANGE(3):GMT_RANGE(2);
range_ref = range_ref';

x_range = linspace(0,1,length(range_ref));
x_initial = linspace(0,1,length(CMAP));

for i=1:3;	
	CMAP_GMT(:,i) = interp1(x_initial,CMAP(:,i),x_range)*255;
end

CMAP_GMT = round(CMAP_GMT);

OUT = [range_ref(1:end-1),CMAP_GMT(1:end-1,:),range_ref(2:end),CMAP_GMT(2:end,:)];


FMT = '%5.3f\t%i\t%i\t%i\t%5.3f\t%i\t%i\t%i\n';

fid = fopen(FILEOUT,'w');
fprintf(fid,FMT,OUT');
fclose(fid);

CMD = sprintf('!echo "B\t%i\t%i\t%i" >> %s',CMAP_GMT(1,1),CMAP_GMT(1,2),CMAP_GMT(1,3),FILEOUT);
eval(CMD)

CMD = sprintf('!echo "F\t%i\t%i\t%i" >> %s',CMAP_GMT(end,1),CMAP_GMT(end,2),CMAP_GMT(end,3),FILEOUT);
eval(CMD)

CMD = ['!echo "N	170	170	170" >> ',FILEOUT];
eval(CMD)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

catch

	[ err_msg ] = get_err_msg;

	ret.code = -1;
        ret.msg = err_msg;

end 
	