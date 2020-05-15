function [ret]=eval_atsha_data(tracks_dir,LON_LIM,LAT_LIM,TFRAME,plotdir,outdir);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	This function:
%  		- Evaluate the along track data availability
%  			 for an especific area
%  		- Plot the tracks for an especific period
%  		- Plot coastal flags according to data availability
%
%		Ricardo Domingues, AOML/NOAA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ret.code=0;
try
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Checking available instruments 

TYPE='vxxc';
%  TYPE='vfec';

instr = dir([tracks_dir,'/*cf']);

instr = {'tp' 'e2' 'g2' 'tpn' 'j1' 'en' 'j2' 'j1n' 'enn'}; 

for i=1:length(instr)
%  	IND=find(instr(i).name=='_');
	Data{i}.instr=instr{i};
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Checking instruments temporal availability

for i=1:length(instr)
	files=dir([tracks_dir,'/',Data{i}.instr,'_cf/*',TYPE,'*nc*']);
	time=[];
	for f=1:length(files)
		file = files(f).name;
		IND=find(file=='_');		
		DATE=file(IND(6)+1:IND(7)-1);
		yyyy=str2num(DATE(1:4));
		mm=str2num(DATE(5:6));
		dd=str2num(DATE(7:8));		

		time(f) = julian(yyyy,mm,dd,0);
	end

	time=sort(time);

	Data{i}.tframe = [nanmin(time) nanmax(time)];

	t_min(i) = nanmin(time);
	t_max(i) = nanmax(time);

end

save([outdir,'/Instra_tframe'],'Data','instr')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plotting instrument availability
t_all = nanmin(t_min):7:nanmax(t_max);

figure(1)
cmap=jet(length(Data));
RNG = abs(nanmin(t_min)-nanmax(t_max));

for i=1:length(instr)
	plot(Data{i}.tframe,[i i],'color',cmap(i,:),'linewidth',2), hold on
%  	instr{i}=Data{i}.instr;
	text(nanmin(t_min)-RNG*.07,i,['\bf ',upper(Data{i}.instr)],'color',cmap(i,:),'fontsize',12);
end
xlim([nanmin(t_min) nanmax(t_max)]);
ylim([0 length(Data)+1])
gregaxy(t_all,1)
set(gca,'yticklabel',[])
set(gca,'ytick',1:length(Data),'fontsize',10)
grid on
pbaspect([1 .6 1])
title('\bf Altimeters temporal availability','fontsize',12)

saveas(gcf,[plotdir,'/ATSHA_instrument_availability'],'png')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plotting availability of different routes
t_all = nanmin(t_min):7:nanmax(t_max);
routes = {'tp' 'e1' 'g2' 'tpn' 'enn'}
instr_routes = [1 2 3 4 1 2 1 4 5];

route_color = {'b' 'r' [0 .6 0] [.6 .6 .6] 'm'};

figure(2)
for i=1:length(instr)	
	plot(Data{i}.tframe,[instr_routes(i) instr_routes(i)],'color',route_color{instr_routes(i)},'linewidth',2), hold on
%  	instr{i}=Data{i}.instr;
	text(nanmin(t_min)-RNG*.07,instr_routes(i),['\bf ',upper(routes(instr_routes(i)))],'color',route_color{instr_routes(i)},'fontsize',12);
end
xlim([nanmin(t_min) nanmax(t_max)]);
ylim([0 length(routes)+1])
gregaxy(t_all,1)
set(gca,'yticklabel',[])
set(gca,'ytick',1:length(Data),'fontsize',10)
grid on
pbaspect([1 .6 1])
title('\bf Altimeters temporal availability','fontsize',12)

saveas(gcf,[plotdir,'/ATSHA_routes_availability'],'png')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plotting instrument availability at AREA

%  instr = {'tp' 'e2' 'g2' 'tpn' 'j1' 'en' 'j2' 'j1n' 'enn'}; 
instr_color = {'b' 'r' [0 .6 0] [.6 .6 .6] 'b' 'r' 'b' [.6 .6 .6] 'k'};
figure(2)
[X,Y,Z]=plot_bathymetry('s',1,LON_LIM,LAT_LIM,20);

for t=1:length(TFRAME)-1
	clf
	m_proj('merc','lat',LAT_LIM,'lon',LON_LIM);

	INST_PLOT = [];
	c=0;
	Handle=[];
	for i=1:length(instr)				
		
		T_aux = Data{i}.tframe(1):7:Data{i}.tframe(2);
		IND_tframe = find(T_aux>julian(TFRAME(t),1,1,0) & T_aux<julian(TFRAME(t+1)-1,12,31,0)); 
	
		if(length(IND_tframe)>25)
			
			lon_ALL =[];
			lat_ALL =[];
	 		i0 = 1;

			c=c+1;
			INST_PLOT{c} = Data{i}.instr;
			files=dir([tracks_dir,'/',Data{i}.instr,'_cf/*',TYPE,'*nc*']);
%  			CMD = ['!gunzip ',tracks_dir,'/',Data{i}.instr,'_cf/*',TYPE,'*nc.gz'];
%  			eval(CMD);
			
			for f=1:length(files)
				
				file = files(f).name;	
				nc=netcdf([tracks_dir,'/',Data{i}.instr,'_cf/',file]);
				lon=nc{'longitude'}(:)*1e-6;
				lat=nc{'latitude'}(:)*1e-6;

				K=find(lon>180);
				lon(K)=lon(K)-360;

				IND_lat = find(lat>LAT_LIM(1) & lat<LAT_LIM(2));				
				lat = lat(IND_lat);
				lon = lon(IND_lat);
				IND_lon = find(lon>LON_LIM(1) & lon<LON_LIM(2));
				lat = lat(IND_lon);
				lon = lon(IND_lon);	

				if(~isempty(lat))
					Handle(c)= m_plot(lon,lat,'.','color',instr_color{i}); hold on
					lon_ALL(i0:i0+length(lon)-1)=lon;
					lat_ALL(i0:i0+length(lon)-1)=lat;
					
					i0=length(lon_ALL);	
				end

				close(nc)

			end

			AUX = unique([lon_ALL',lat_ALL'],'rows');
			lon_ALL = AUX(:,1);
			lat_ALL = AUX(:,2);

%  			CMD = ['!gzip ',tracks_dir,'/',Data{i}.instr,'_cf/*',TYPE,'*nc'];
%  			eval(CMD);

			save([outdir,'/',Data{i}.instr,'_track'],'lon_ALL','lat_ALL');
		end

	end
	
	m_contour(X,Y,Z,[-100 -8000],'k')
	m_contour(X,Y,Z,[-1000 -8000],'k--')

	m_gshhs_i('patch',[0 0 0], 'edgecolor',[0.4 0.4 0.4]);
	m_grid('box','fancy','fontsize',12)

	title(['\bf Period: ',num2str(TFRAME(t)),'-',num2str(TFRAME(t+1))],'fontsize',13);

	CMD=['legend(Handle,'];
	for i=1:length(INST_PLOT)		
		if(i==length(INST_PLOT))
			CMD=[CMD,'''',upper(INST_PLOT{i}),'''',','];
		else
			CMD=[CMD,'''',upper(INST_PLOT{i}),'''',','];
		end
	end
	CMD=[CMD,'''location'',''northeast'');'];
	eval(CMD)

	saveas(gcf,[plotdir,'/available_ALT_',num2str(TFRAME(t)),'-',num2str(TFRAME(t+1))],'png')

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

catch

	[ err_msg ] = get_err_msg;

	ret.code = -1;
        ret.msg = err_msg;

end 



	
