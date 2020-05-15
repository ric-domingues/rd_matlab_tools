function [tseries_OUT,Inans]=fillnans_RD(tseries);

%  function [tseries_OUT,Inans]=fillnans_RD(tseries);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	This function fill the missing data in a time-series with white noise
%
%		Ricardo Domingues, AOML/NOAA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
STD0 = nanstd(tseries(:)); % Standard deviation from the original time-series
MN0 = nanmean(tseries); % Mean from the original time-series
MASK = find(isnan(tseries));
Inans = MASK;

t_aux = rand(1,length(tseries));
t_aux = (t_aux - nanmean(t_aux))./nanstd(t_aux);
t_aux = t_aux*STD0 + MN0;
tseries(MASK) = t_aux(MASK);

tseries_OUT = tseries;