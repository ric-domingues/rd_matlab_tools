function [COR,WID,LAG] = coherence_RD(T1,T2,WID,MAXLAG);

%  function [COR,WID,LAG] = coherence_RD(T1,T2,WID,LAG);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  	This function calculates the correlations between T1 and T2 after the
%  		filtering the time-series with differents WIDSs
%  		
%  		Ricardo Domingues, AOML/NOAA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

T1_aux = T1;
T2_aux = T2;

for i=length(WID):-1:1

	WID_use = WID(i)
	if(iseven(WID_use)),WID_use=WID_use+1;end

	T1_aux = rmean(T1,WID_use);
	T2_aux = rmean(T2,WID_use);

	T1_use = T1-T1_aux;
	T2_use = T2-T2_aux;

	K=isnan(T1_use);
	T1_use(K)=[];
	T2_use(K)=[];
	
	K=isnan(T2_use);
	T1_use(K)=[];
	T2_use(K)=[];
	
	[max_ccx, max_lag,significance_90] = check_corr4(T1_use',T2_use','te','et',MAXLAG,0)

	COR(i) = max_ccx;
	LAG(i) = max_lag;
	
end







