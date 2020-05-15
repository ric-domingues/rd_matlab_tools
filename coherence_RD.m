function [COR,WID,LAG,SIGLEVEL] = coherence_RD(T1,T2,WID,MAXLAG,ALPH);

%  function [COR,WID,LAG,SIGLEVEL] = coherence_RD(T1,T2,WID,LAG,ALPH);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  	This function calculates the correlations between T1 and T2 after the
%  		filtering the time-series with differents WIDSs
%  		
%  		Ricardo Domingues, AOML/NOAA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

L0=length(T1); % length of the samples
if(~exist('ALPH'))
	ALPH=0.05;
end

%  disp('AUSHAU')

L0=length(T1);

for i=1:length(WID)

	DF = (L0./WID - 2); %degree of freedon for paired samples

	WID_use = WID(i)
	if(iseven(WID_use)),WID_use=WID_use+1;end

	T1_use = T1;
	T2_use = T2;
%  	T1_use = rmean(T1,WID_use);
	T2_use = rmean(T2,WID_use);

	K=isnan(T1_use);
	T1_use(K)=[];
	T2_use(K)=[];
	
	K=isnan(T2_use);
	T1_use(K)=[];
	T2_use(K)=[];
		
	[max_ccx, max_lag,significance_90] = check_corr4(T1_use',T2_use','te','et',MAXLAG,0);
	
	R = corrcoef(T1_use,T2_use);
	max_ccx = R(2,1)

	COR(i) = max_ccx;
	LAG(i) = max_lag;


	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% Getting the significance level;

	DF = round(L0./WID(i))-2; %degree of freedon for paired samples
	tvalue = t_table(ALPH./2,DF);
	
	SIGLEVEL(i) = sqrt(tvalue.^2./(DF+tvalue.^2)); 
	
end






