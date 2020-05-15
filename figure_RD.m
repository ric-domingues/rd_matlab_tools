function figure_RD(X,Y)

%  function colorbar_RD(tp)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  
%  	This program opens a nice figure
%  	
%  		Ricardo Domingues, AOML/NOAA
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



if(~exist('X'))
	X = 8;
end

if(~exist('Y'))
	Y = 10;
end

figure
PL=auto_plot(1,1,1,.5,.7,1,1,X,Y);
AXPOS=get(gca,'position');
axis off
axes
set(gcf,'paperorientation','portrait')


%  
%  set(gca,'position',[.15 .15 .7 .75])


%  figure('PaperSize',[2 10])