function h=fill_error(time,Y,ERR,COLOR,ORIE,OP,LINSTYLE,LINCOLOR,LINWIDTH);
%  function h=fill_error(time,Y,ERR,COLOR,ORIE,OP,LINSTYLE,LINCOLOR,LINWIDTH);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 		Fill polygon with COLOR to highlight periods in the time-series 
%  
%  			OP = 0, no fill (default = 1)
%  			LINSTYLE, default = '-'
%  			LINCOLOR, default = 'k'
%  			LINWIDTH, default = .5
%  			ORIE = 0 , plot error bar on X axis
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

if(~exist('COLOR'))
	COLOR='r';
end

if(~exist('ORIE'))
	ORIE=1;
end

if ORIE

	XV = [time,time(end:-1:1),time(1)];
	YV = [Y+ERR,Y(end:-1:1)-ERR(end:-1:1),Y(1)+ERR(1)];
else

	YV = [time,time(end:-1:1),time(1)];
	XV = [Y+ERR,Y(end:-1:1)-ERR(end:-1:1),Y(1)+ERR(1)];
	disp('OK')
end


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
	

