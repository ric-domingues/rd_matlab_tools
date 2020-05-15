function [AX,H1,H2]=plotyy_RD(time,T1,T2,YLABEL1,YLABEL2,COR1,COR2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  	
%  		This function apply plotyy nicely
%  		
%  			Ricardo Domingues, AOML/NOAA
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if(~exist('COR2'))
	COR2='r';
end

if(~exist('COR1'))
	COR1='k';
end

NTICKS=5;


YLIM1 = [nanmin(T1)-0.05*range(T1) nanmax(T1)+0.05*range(T1)];
YLIM2 = [nanmin(T2)-0.05*range(T2) nanmax(T2)+0.05*range(T2)];

[AX,H1,H2] = plotyy(time,T1,time,T2);
set(H1,'color',COR1)
set(H2,'color',COR2)
set(AX(1),'ycolor',COR1,'xtick',[],'xticklabel',[])
set(AX(2),'ycolor',COR2,'xtick',[],'xticklabel',[])
axes(AX(1))
xlim([nanmin(time) nanmax(time)])
ylim(YLIM1)

box off
axes(AX(2))
xlim([nanmin(time) nanmax(time)])
ylim(YLIM2)
box off



if(exist('YLABEL1'))
	ylabel(AX(1),YLABEL1,'fontsize',12)
end

if(exist('YLABEL2'))
	ylabel(AX(2),YLABEL2,'fontsize',12)
end



