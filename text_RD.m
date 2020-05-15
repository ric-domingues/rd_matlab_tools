function text_RD(TEXT,TSIZE,BCOLOR,LOC,DY)

%  function text_RD(TEXT,TSIZE,BCOLOR,LOC,DY)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  	This function includes the TEXT in the specified corner of each plot
%  
%  
%  
%  		TEXT - text to plot
%		TSIZE - fontsize  
%  		BCOLOR - color for the background (default is empty background)
%  		LOC - location for the text (default is north)
%		DY - distance between north/south axis (default is .1)  
%  
% 		Ricardo Domingues, AOML/NOAA 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

XLIME=xlim;
YLIME=ylim;

RNG_X = XLIME(2) - XLIME(1);
RNG_Y = YLIME(2) - YLIME(1);

if(~exist('LOC'))
	LOC='north';
end

if(~exist('TSIZE'))
	TSIZE=10;
end

if(~exist('BCOLOR'))
	BCOLOR=[];
end

if(~exist('DY'))
	DY=.1;
end

DX = .02;

if(strmatch(LOC,'south'))
	disp('OK')
	XCOOR = XLIME(1)+RNG_X*DX;
	YCOOR = YLIME(1)+RNG_Y*DY;
else
	XCOOR = XLIME(1)+RNG_X*DX;
	YCOOR = YLIME(2)-RNG_Y*DY;
end

if(isempty(BCOLOR))
	text(XCOOR,YCOOR,TEXT,'fontsize',TSIZE)

else
	if(strmatch(BCOLOR,'k'))
		text(XCOOR,YCOOR,TEXT,'fontsize',TSIZE,'color','w','backgroundcolor',BCOLOR)
	else
		text(XCOOR,YCOOR,TEXT,'fontsize',TSIZE,'backgroundcolor',BCOLOR)
	end
end




