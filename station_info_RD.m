function station_info_RD(lon,lat,info,DX)

%  function station_info_RD(lon,lat,info,DX)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   	This program plot information about a point in the map
%  
%  		Ricardo Domingues, AOML/NOAA
%  
%  
%		info - text about station
%		DX - text distance from the point (default = 0.3)   
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if(~exist('DX'))
	DX=0.3;
end

m_plot(lon,lat,'gv','markersize',7,'markerfacecolor','g')
h=m_text(lon+DX,lat+DX,info,'backgroundcolor',[.99 .99 .99],'edgecolor','g','margin',1.5,'fontsize',9);
m_plot([lon lon+DX],[lat lat+DX],'g-')












