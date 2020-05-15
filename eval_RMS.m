function [RMS,WID] = eval_RMS(T1,T2,WID);

%  function [COR,WID,LAG,SIGLEVEL] = coherence_RD(T1,T2,WID,LAG,ALPH);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  	This function evaluates the RMS as a function of filter width
%  		
%  		Ricardo Domingues, AOML/NOAA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

L0=length(T1);

for i=1:length(WID)

	WID_use = WID(i);
	if(iseven(WID_use)),WID_use=WID_use+1;end

	T1_use = T1;
%  	T1_use = rmean(T1,WID_use);
	T2_use = rmean(T2,WID_use);

	K=isnan(T1_use);
	T1_use(K)=[];
	T2_use(K)=[];
	
	K=isnan(T2_use);
	T1_use(K)=[];
	T2_use(K)=[];
		
	DIFF = T1_use-T2_use;
	RMS(i) = sqrt(mean(DIFF.^2));
	
end






