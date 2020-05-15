function h=fill_period(STARTDATE,ENDDATE,COLOR,OP,LINSTYLE,LINCOLOR,LINWIDTH);

%  h=fill_period(STARTDATE,ENDDATE,COLOR,OP,LINSTYLE,LINCOLOR,LINWIDTH);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 		Fill polygon with COLOR to highlight periods in the time-series 
%  
%  			OP = 0, no fill (default = 1)
%  			LINSTYLE, default = '-'
%  			LINCOLOR, default = 'k'
%  			LINWIDTH, default = .5
%  
%  
%  		Ricardo Domingues, AOML/NOAA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

YLIME = get(gca,'ylim');
hold on

if(~exist('LINSTYLE'))
	LINSTYLE='-';
end

if(~exist('LINCOLOR'))
	LINCOLOR='k';
end

if(~exist('LINWIDTH'))
	LINWIDTH=.5;
end

XV = [STARTDATE,STARTDATE,ENDDATE,ENDDATE,STARTDATE];
YV = [YLIME(1),YLIME(2),YLIME(2),YLIME(1),YLIME(1)];

h=fill(XV,YV,COLOR);
set(h,'linewidth',.3)
ylim(YLIME)


if(~exist('OP'))
	OP=1;
end

set(h,'linestyle',LINSTYLE,'edgecolor',LINCOLOR,'linewidth',LINWIDTH)

if(OP==0)
	set(h,'facecolor','none')
end
	

