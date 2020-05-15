function [res,annsig,ANN365,STD365] = get_residuals_RD(time,tseries,SMOO)

%  function [res,annsig,ANN365,STD365] = get_residuals_RD(time,tseries,SMOO)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  	This function removes the annual signal from the data
% 		Note: Minimum of 3 years recommended
%   
%    		Ricardo Domingues, AOML/NOAA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
res = nan;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if(~exist('SMOO'))
SMOO=0;
end

[MM,NN] = size(tseries);
tseries = reshape(tseries,MM*NN,1);
time = reshape(time,MM*NN,1);

time_ref = nanmin(time(:)):1:nanmax(time(:));
t = interp1(time,tseries,time_ref);
%  t=rmean(t,91); %monthly running mean
%  t = t - nanmean(t);
%  t=rmean(t,31); %monthly running mean
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  calc residuals

greg = gregorian(time_ref);
yyyy=greg(:,1);
mm=greg(:,2);
dd=greg(:,3);

for i=1:length(time_ref)

	IND = find(mm==mm(i) & dd==dd(i));
	annual_signal(i) = nanmean(t(IND));
	std_signal(i) = nanstd(t(IND));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%  plot(time_ref,annual_signal)
%  gregaxy(time,1)

if SMOO
  annual_signal = rmean(annual_signal,31);
  std_signal = rmean(std_signal,31);
end

annsig = interp1(time_ref,annual_signal,time);

%  plot(time_ref,annual_signal)
%  gregaxm(time_ref,1)

res = tseries - annsig;

greg = gregorian(nanmin(time_ref));
yyyy = greg(1)+1;

time365d = julian(yyyy,1,0,0)+[1:365];

ANN365 = interp1(time_ref,annual_signal,time365d);
STD365 = interp1(time_ref,std_signal,time365d);





%  t_ANN = (mm-1) + dd/30.4167;  
%  
%  [t_ANN,Iann] = unique(t_ANN);
%  ANN365 = annual_signal(Iann);
%  STD365 = std_signal(Iann);
%  
%  [t_ANN,Iann_s] = sort(t_ANN);
%  ANN365 = ANN365(Iann_s);
%  STD365 = STD365(Iann_s);
%  
%  ANN365 = ANN365(1:365);
%  STD365 = STD365(1:365);
