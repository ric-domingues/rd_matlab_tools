function ret=eval_tide(filetide,figout,tidecomponentsfile,TITLE,matfileout,lon,lat)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	This program uses the T_TIDE package to evaluate the tidal components
%  		of pressure data on the SOEST format (use wocehr.x).
%
%
%		Ricardo Domingues, AOML/NOAA
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ret.code=0;

try
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
v=load(filetide);

disp(' - Calculating tides')

time=julian(v(:,1),v(:,2),v(:,3),v(:,4));
slevel = v(:,5);



K=find(slevel==9999);
slevel(K)=nan;
slevel=slevel./1000;
slevel2=slevel-nanmean(slevel);

if(abs(v(1,1)-v(end,1)) > 16)

  HID = round(length(slevel)./2);
  
  [tidal_components,t_predict1]=t_tide(slevel(1:1*HID),'output',tidecomponentsfile);
  
  [tidal_components,t_predict2]=t_tide(slevel(HID+1:end),'output',tidecomponentsfile);  

  t_predict = [t_predict1;t_predict2];
  
  
else

  [tidal_components,t_predict]=t_tide(slevel,'output',tidecomponentsfile);  

  
end 

save(matfileout,'tidal_components','t_predict','slevel2','time','lon','lat')

disp(' - Tidal Components Calculated')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	Plotting

IND1 = round(length(time)*0.4);
IND2 = round(length(time)*0.6);

PL=auto_plot(1,3,1,.5,.7,.6,.6,11,9);

plot(time,slevel2-t_predict,'b')
xlim([time(IND1) time(IND2)])
gregaxm(time,4)
ylabel('\bf Observed Sea Level - Predicted Tide [m]','fontsize',12)

set(gca,'handlevisibility','off')

plot(time,t_predict,'r'), hold on
plot(time,slevel2,'k')
ylabel('\bf Sea Level [m]','fontsize',12)
xlim([time(IND1) time(IND2)])
gregaxm(time,4)

set(gca,'handlevisibility','off')


h1=plot(time,t_predict,'r'); hold on
h2=plot(time,slevel2,'k');
gregaxy(time,1)
ylabel('\bf Sea Level [m]','fontsize',12)

title(TITLE,'fontsize',14)

legend([h1 h2],'Predicted Tide', 'Observed Sea Level')

set(gca,'handlevisibility','off')
set(gca,'handlevisibility','off')


set(gcf,'paperorientation','portrait')
%  saveas(gcf,figout,'png')



pause(2)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
catch

	[ err_msg ] = get_err_msg

	ret.code = -1
        ret.msg = err_msg

end 

