function [corrc, lags, MAX, LAG, T2_lagged] = lagged_corr_RD(T1,T2,MAXLAG);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	Uses function check_corr5. to get lagged correlation  
%  
%  		Ricardo Domingues
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
corrc=nan;lags=nan; MAX=nan; LAG=nan; T2_lagged =nan;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[MM,NN] = size(T1);

T1_use = reshape(T1,1,MM*NN);
T2_use = reshape(T2,1,MM*NN);

K=isnan(T1_use);
T1_use(K)=[];
T2_use(K)=[];

if(isempty(T1_use))
	return
end

K=isnan(T2_use);
T1_use(K)=[];
T2_use(K)=[];

if(isempty(T2_use))
	return
else
	if(length(T2_use)<(MAXLAG+MAXLAG/2))
		return
	end
end

[max_ccx, max_lag, corrc, lags, significance_90] =  check_corr5_RD(T1_use',T2_use','te','et',MAXLAG,0);
%  corrc(1:MAXLAG-1)=nan;

[MAX,I]=nanmax(abs(corrc));
MAX = corrc(I); 
LAG=lags(I);
%  LAG=0;

if(LAG==0)
	T2_aux=T2;
elseif(LAG>0)
	T2_aux = nan(1,length(T1));
	T2_aux(LAG:end)=T2(1:end-LAG+1);
elseif(LAG<0)
	T2_aux = nan(1,length(T1));
	T2_aux(1:end-abs(LAG)+1)=T2(abs(LAG):end);
end

T2_lagged = T2_aux;
%  
%  
%  figure
%  [ax,h1,h2]=plotyy(1:length(T1),T2,1:length(T1),T1), hold on
%  plot(1:length(T1),T2_aux,'r')
%  pause



