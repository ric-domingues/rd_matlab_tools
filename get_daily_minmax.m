function [Dmin,Dmax] = get_daily_minmax(time_ref,time_use,tseries)

%  function [Dmin,Dmax] = get_daily_minmax(time_ref,time_use,tseries)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
%    		Ricardo Domingues, AOML/NOAA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
res = nan;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Dmin = nan(size(time_ref));
Dmax = nan(size(time_ref));

greg = gregorian(time_ref);
yyyy=greg(:,1);
mm=greg(:,2);
dd=greg(:,3);

for i=1:length(time_ref)

	IND = find(time_use>=julian([yyyy(i),mm(i),dd(i),0,0,0]) & time_use<=julian([yyyy(i),mm(i),dd(i),23,59,0]));
	
	  if(~isempty(IND))
	      Dmax(i) = nanmax(tseries(IND));
	      Dmin(i) = nanmin(tseries(IND));	
	  end
  	
end

