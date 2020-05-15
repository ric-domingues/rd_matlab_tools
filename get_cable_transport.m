function [ret]=get_cable_transport(datadir,plotdir);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	This function gets the cable transport and calculate related statistics
%
%		Ricardo Domingues, AOML/NOAA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ret.code=0;
try
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	ALTcablefile = [datadir,'/ALT_FC_tran.dat'];
	MT = load(ALTcablefile);
	
	DATE = num2str(MT(:,1));
	transp = MT(:,2);
	
	yyyy = str2num(DATE(:,1:4));
	mm = str2num(DATE(:,5:6));
	dd = str2num(DATE(:,7:8));

	time=julian(yyyy,mm,dd,0);
	
	ctransp=transp;
	transp=ctransp;
	
	ALTtransp = ctransp;
	
%  %  	plot(time,ALTtransp), pause
%  %  	return

	time_i = time(1):7:time(end);
	transp_i = interp1(time,transp,time_i);
	
	transp_s1 = rmean(transp_i,13);

	save([datadir,'/ALT_FC_transport'],'time','ALTtransp')
	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	cablefile = [datadir,'/cable_tran_t.dat'];
	MT = load(cablefile);
	
	DATE = num2str(MT(:,1));
	transp = MT(:,2);
	
	yyyy = str2num(DATE(:,1:4));
	mm = str2num(DATE(:,5:6));
	dd = str2num(DATE(:,7:8));

	time=julian(yyyy,mm,dd,0);
	
	ctransp=transp;
	ctransp(find(diff(time)>1))=nan;
	transp=ctransp;

	time_i = time(1):7:time(end);
	transp_i = interp1(time,transp,time_i);
	
	transp_s1 = rmean(transp_i,13);

	save([datadir,'/Cable_transport'],'time','ctransp')
		
	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plotting
MASK = find(isnan(ctransp));
ctransp_s = rmean(ctransp,31);
ctransp_s(MASK)=nan;

ii=0;key=0;
for i=1:length(time_i);

	if(key == 0 & isnan(transp_i(i)));
		ii=ii+1;
		INI_fill(ii) = time_i(i);
		key=1;
	end

	if(key==1 & ~isnan(transp_i(i)))
		END_fill(ii) = time_i(i);
		key=0;
	end
end

DIFE = END_fill - INI_fill;
END_fill(DIFE<15) = [];
INI_fill(DIFE<15) = [];
%  
%  plot(diff(TIME_fill))
%  pause
%  return

figure
my_graph_properties
PL=auto_plot(1,1,1,.4,.7,1,.7,3.5,9);
ylim([25 40])
for i = 1:length(INI_fill)
	fill_period(INI_fill(i),END_fill(i),[.8 .0 .0]), hold on
end

plot(time,ctransp,'color',[.7 .7 .7],'linewidth',.3); hold on
plot(time,ctransp_s,'k','linewidth',1); 
xlim([julian(1984,1,1,0) julian(2010,12,31,0)])
gregaxy(time,2);
ylabel('\bf FLC transport [Sv]')
ylim([25 40])
my_graph_properties

%------------ Trend -------------------

%  IND_time = find(time>=julian(1993,1,1,0) & time<=julian(2011,12,31,0));
%  
%  tseries = ctransp(IND_time);
%  time_aux = time(IND_time);
%  
%  P = polyfit(time_aux(~isnan(tseries)),tseries(~isnan(tseries)),1);
%  tnd2 = polyval(P,time_aux);
%  greg_aux = gregorian(time_aux);
%  yr1 = greg_aux(1,1);
%  yr2 = greg_aux(end,1);
%  
%  [r,prob]=corrcoef(time_aux(~isnan(tseries)),tseries(~isnan(tseries)));
%  K=find(prob<0.1)
%  	
%  tnd = (tnd2(end)-tnd2(1))/(yr2-yr1)*10%anom/decade
%  
%  plot(time_aux,tnd2,'r','linewidth',1);
%  text(julian(1993,6,1,0),43,['\bf Trend = ',num2str(tnd),' [Sv/decade]'])


saveas(gcf,[plotdir,'/transp_CABLE'],'psc')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Running the wavelets

transp_i = fillnans_RD(transp_i);

%-------------testest---------------------------
%  transp_i = rmean_hf(transp_i,106); % tests
%  transp_i = rmean(transp_i,27);% tests 
%-------------testest---------------------------

figure
%  PL=auto_plot(1,1,1,1,.6,.6,.5,4,7);axis off
axes('position',[.11 .2 .6 .5])
my_graph_properties
wavelet_SA(time_i,transp_i,[-2 1.5],4,1,0);
%  pbaspect([.9 .5 1])
ylabel('\bf Period [Years]')
%  my_graph_properties
grid_RD
text_RD('Wavelet FLC transport',12,'w')

axes('position',[.72 .2 .2 .5])
my_graph_properties
ctransp_7d = rmean(ctransp,7);
[p,power]=fft_RD(time,ctransp_7d,0);
plot(power,log2(p),'b','linewidth',2)
set(gca,'ydir','reverse','ytick',-3:1:3,'yticklabel',[]);
get(gca,'ytick')
ylim([-3.7 3.4])
xlim([0 3])
my_graph_properties
xlabel('\bf PSD')


saveas(gcf,[plotdir,'/wave_CABLE'],'psc')

pause

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

catch

	[ err_msg ] = get_err_msg

	ret.code = -1;
        ret.msg = err_msg;

end 



	