function [WT,time,period,C95,COI,WTpower] = wavelet_SA(time,tseries,CAX,S0,PL,CBPL)
%  function [WT,time,period] = wavelet_SA(time,tseries,CAX,S0,PL,CBPL)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% waveletsa = wavelet_SA(data_in,data_out,coi_out,sig95_out,param_out)
%
% data_in: time series data to make the PWS (input)
% data_out: PWS results to be plotted (output)
% coi_out: COI points to be plotted (output)
% sig95_out: 95% significance contour to be plotted (output)
% param_out: other parameters necessary to make the plots
%%
% See "http://paos.colorado.edu/research/wavelets/"
% Written January 1998 by C. Torrence
%
% Modified Oct 1999, changed Global Wavelet Spectrum (GWS) to be sideways,
%   changed all "log" to "log2", changed logarithmic axis on GWS to
%   a normal axis.
%
%
%	Modified by R. Domingues, Jan-2012.: -Loading time-series from mat files
%					     -Saving outputs to matfiles
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if(~exist('PL'))
	PL=1;
end

if(~exist('CBPL'))
	CBPL=1;
end


format long g

SAMP = round(nanmean(diff(time)));
%  SAMP = 7
%  K=isnan(tseries);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Filling roles in the time-series with white noise, with the original standard deviation;
%  %  %  tseries=inpaint_nans(tseries,5);

STD0 = nanstd(tseries(:)); % Standard deviation from the original time-series
MN0 = nanmean(tseries); % Mean from the original time-series
MASK = find(isnan(tseries));

t_aux = rand(1,length(tseries));
t_aux = (t_aux - nanmean(t_aux))./nanstd(t_aux);
t_aux = t_aux*STD0 + MN0;
tseries(MASK) = t_aux(MASK);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

greg = gregorian(time);
time_aux= [greg(:,1) + greg(:,2)/12 + greg(:,3)/365]';
data_in = [time_aux',tseries'];

%  all_data = load(data_in);   % input SST time series
all_data = data_in;
first_yr = all_data(1,1);
last_yr = all_data(end,1);
ts = all_data(:,2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Computation

% normalize by standard deviation (not necessary, but makes it easier
% to compare with plot on Interactive Wavelet page, at
% "http://paos.colorado.edu/research/wavelets/plot/"
variance = nanstd(ts)^2;
ts = (ts - nanmean(ts))/sqrt(variance);

n = length(ts);
dt = 7/365 ; % Sampling frequency 
time = [0:length(ts)-1]*dt + first_yr ;  % construct time array
xlim = [first_yr,last_yr];  % plotting range
pad = 1;      % pad the time series with zeroes (recommended)
dj = 0.025;    % this will do 4 sub-octaves per octave
s0 = S0*dt;    % this says start at a scale of 2 weeks
j1 = 7/dj;    % this says do 7 powers-of-two with dj sub-octaves each
lag1 = 0.72;  % lag-1 autocorrelation for red noise background
mother = 'Morlet';

% Wavelet transform:
[wave,period,scale,coi] = wavelet(ts,dt,pad,dj,s0,j1,mother);
power = (abs(wave)).^2 ;        % compute wavelet power spectrum

% Significance levels: (variance=1 for the normalized SST)
[signif,fft_theor] = wave_signif(1.0,dt,scale,0,lag1,-1,-1,mother);
sig95 = (signif')*(ones(1,n));  % expand signif --> (J+1)x(N) array
sig95 = power ./ sig95;         % where ratio > 1, power is significant

% Global wavelet spectrum & significance levels:
global_ws = variance*(sum(power')/n);   % time-average over all times
dof = n - scale;  % the -scale corrects for padding at edges
global_signif = wave_signif(variance,dt,scale,1,lag1,-1,dof,mother);

% Scale-average between El Nino periods of http://www.wonderwheeler.com/2--8 years
avg = find((scale >= 2) & (scale < 8));
Cdelta = 0.776;   % this is for the MORLET wavelet
scale_avg = (scale')*(ones(1,n));  % expand scale --> (J+1)x(N) array
scale_avg = power ./ scale_avg;   % [Eqn(24)]
scale_avg = variance*dj*dt/Cdelta*sum(scale_avg(avg,:));   % [Eqn(24)]
scaleavg_signif = wave_signif(variance,dt,scale,2,lag1,-1,[2,7.9],mother);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Plotting

load wavecmap


%--- Contour plot wavelet power spectrum
%subplot('position',[0.1 0.37 0.65 0.28])
levels = [0.0625,0.125,0.25,0.5,1,2,4,8,16] ;
log2levels = linspace(-20,20,30);
Yticks = 2.^(fix(log2(min(period))):fix(log2(max(period))));
WT = log10(power);
WTpower = power;
C95 = contourc(time,period,sig95,[-99,1]);
K = find(C95(1,:)<1900);
C95(:,K) = nan;
COI = coi;

if PL
	colormap(cmap)
	%  contourf(time,log2(period),log2(power),50);  shading flat
	

	pcolor(time,log2(period),WT);  shading flat
	caxis(CAX);
	
	TICK=get(gca,'xtick');
	set(gca,'xtick',TICK)
	set(gca,'XLim',xlim(:))
	set(gca,'YLim',log2([min(period),max(period)]), ...
		'YDir','reverse', ...
		'YTick',log2(Yticks(:)), ...
		'YTickLabel',Yticks)
	set(gca,'fontsize',11)
	% 95% significance contour, levels at -99 (fake) and 1 (95% signif)
	hold on
	contour(time,log2(period),sig95,[-99,1],'w','linewidth',1.5);


	% cone-of-influence, anything "below" is dubious
	XLIM = xlim; RNG_X = XLIM(2) - XLIM(1);
	YLIM = ylim; RNG_Y = YLIM(2) - YLIM(1);
	
	XV = [(XLIM(1)+RNG_X*.85),XLIM(2),XLIM(2),(XLIM(1)+RNG_X*.85),(XLIM(1)+RNG_X*.85)];
	YV = [YLIM(1),YLIM(1),(YLIM(2)-RNG_Y*.6),(YLIM(2)-RNG_Y*.6),YLIM(1)];
	plot(time,log2(coi),'k--','linewidth',1.5)

	if CBPL	
		fill(XV,YV,'w')
		
		a1=gca;
		POS = get(gca,'position');
		
		cb=colorbar('vertical');
		POScb = get(cb,'position');
		
		set(a1,'position',POS)
		%  set(cb)
		%  set(cb,'position',[POScb(1)+.005,POScb(2)+0.505,POScb(3)-.015,POScb(4)-.54])
		set(cb,'position',[POScb(1)+.005,POScb(2)+0.505,POScb(3)-.015,POScb(4)-.64])
		set(cb,'ytick',[ceil(CAX(1)) floor(CAX(2))])
		set(cb,'handleVisibility','off')
	end
end
return
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	OUTPUT FILES

%------------------------------------------ ASCII

%  
%  
%  % Printing WPS results (fsal1) and cone-of-influence (fsal2):
%  fsal1 = fopen(data_out,'w');
%  fsal2 = fopen(coi_out,'w');
%  for i = 1 : length(time)
%     for j = 1 : length(period)
%        fprintf( fsal1,'%22.15f  %22.15f  %22.15f\n', time(i), period(j), power(j,i) );
%     end
%     fprintf(fsal2,'%22.15f  %22.15f\n', time(i), coi(i));
%  end
%  fclose(fsal1);
%  fclose(fsal2);
%  
%  % Printing the 95% significance contour
%  C95 = contourc(time,period,sig95,[-99,1]);
%  fsal = fopen(sig95_out,'w');
%  for i = 1 : length(C95)
%     fprintf(fsal,'%22.15f  %22.15f\n', C95(2*i-1), C95(2*i));
%  end
%  fclose(fsal);
%  
%  % Printing other necessary parameters in input file
%  fsal = fopen(param_out,'w');
%  text='Xmin Xmax Ymin Ymax';
%  fprintf(fsal,'%22.15f\t%22.15f\t%22.15f\t%22.15f\t%30s\n', first_yr, last_yr, min(period), max(period), text);
%  text='Min(Z) Max(Z) (to create the color palette)';
%  fprintf(fsal,'%22.15f\t%22.15f\t\t%30s\n', min(min(power)), max(max(power)), text);
%  fclose(fsal);
%  
%  %clear;
%  
%  % end of code
%  
%  %---------- end of file ----------------
