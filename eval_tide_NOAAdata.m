function ret=eval_tide_NOAAdata(filetide,figout,tidecomponentsfile,TITLE,matfileout)

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
filetide

v=load(filetide);

disp(' - Calculating tides')

lat = v(1,1);
lon = v(1,2);

time_secsince1970 = v(:,3);

ONESaux = ones(length(time_secsince1970),1);

time = julian([1970.*ONESaux 1.*ONESaux 1.*ONESaux 0.*ONESaux 0.*ONESaux time_secsince1970]);

slevel = v(:,4);

%================================================================================
%  Filling gaps in data with NaNs

%  K=find(slevel==9999);
%  slevel(K)=nan;
%  slevel=slevel./1000;

[time,Iuni] = unique(time);
slevel = slevel(Iuni);

[time,Iuni] = sort(time);
slevel = slevel(Iuni);
s_aux = ones(size(slevel));
s_aux(2:2:end) = 0;

time_use = nanmin(time):1/24:nanmax(time);

slevel_interp = interp1(time,slevel,time_use);
s_aux_interp = interp1(time,s_aux,time_use);

Knan = find(s_aux_interp>=0.0001 & s_aux_interp<=0.9999);
slevel_interp(Knan) = nan;

slevel = slevel_interp';
time = time_use;

slevel2 = slevel-nanmean(slevel);

%================================================================================


greg = gregorian(time);

DIF = abs(greg(1,1)-greg(end,1))

if(DIF > 16)

  HID = round(length(slevel)./2);

  slevel_test = slevel(1:1*HID);

  [tidal_components,t_predict1]=t_tide(slevel(1:1*HID),'output',tidecomponentsfile);

  disp('I am here')
  
  [tidal_components,t_predict2]=t_tide(slevel(HID+1:end),'output',tidecomponentsfile);  

  t_predict = [t_predict1;t_predict2];
  
  
else

  [tidal_components,t_predict]=t_tide(slevel,'output',tidecomponentsfile);  
  
end 

save(matfileout,'tidal_components','t_predict','slevel2','time','lon','lat','slevel')

disp(' - Tidal Components Calculated')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	Calculating daily SL minus tides

disp(' - Getting daily sea level Detided')

MEAN_SL = nanmean(slevel);

time_1d = nanmin(time):1:nanmax(time);
SL_aux = rmean(slevel2 - t_predict,24) + MEAN_SL;

SL_1d = interp1(time,SL_aux,time_1d);
time_1d_GMT = time_jul2GMT(time_1d);

save(matfileout,'*1d*','-append')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	Calculating Monthly

disp(' - Getting Monthly Sea Level Detided')


yyyy_start = floor(nanmin(time_1d_GMT));
yyyy_end = ceil(nanmax(time_1d_GMT));

c=0;
for y=yyyy_start:1:yyyy_end
	for mm=1:12
		c=c+1;
		time_1m(c) = julian(y,mm,15,0);
	end
end


SL_aux = rmean(SL_1d,31);

SL_1m = interp1(time_1d,SL_aux,time_1m);
time_1m_GMT = time_jul2GMT(time_1m);

save(matfileout,'*1m*','-append')



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	Plotting
return

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

	% ret.code = -1
 %    ret.msg = err_msg

end 

