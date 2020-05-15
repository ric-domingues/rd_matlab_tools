function [COR,WID,LAG,SIG] = coherence2D_RD(T1,T2,WID,MAXLAG,ALPH,PL,UNITS);

%  [COR,WID,LAG,SIG] = coherence2D_RD(T1,T2,WID,MAXLAG,ALPH);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  	This function calculates the correlations between T1 and T2 after the
%  		filtering the time-series with differents WIDSs and applying different lags
%  		
%  		Ricardo Domingues, AOML/NOAA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

L0=length(T1); % length of the samples
if(~exist('ALPH'))
	ALPH=0.05;
end

if(~exist('PL'))
	PL=0;
end

if(~exist('UNITS'))
	UNITS='sampling units';
end


[mm,nn]=size(T1);if(mm>1),T1=T1';end
[mm,nn]=size(T2);if(mm>1),T2=T2';end

for i=1:length(WID)

	DF = round(L0./WID(i))-2; %degree of freedon for paired samples

	WID_use = WID(i);
	if(iseven(WID_use)),WID_use=WID_use+1;end

	T1_use = rmean(T1,WID_use);
	T2_use = rmean(T2,WID_use);

	K=isnan(T1_use);
	T1_use(K)=[];
	T2_use(K)=[];
	
	K=isnan(T2_use);
	T1_use(K)=[];
	T2_use(K)=[];
		
	[max_ccx, max_lag, corrc, lags, significance_90] =  check_corr5_RD(T1_use',T2_use','te','et',MAXLAG,0);

	COR(i,:) = corrc;

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% Testing the significance of the correlations

	tcorr = abs(corrc).*(sqrt(DF)./sqrt(1-corrc.^2));
	tvalue = t_table(ALPH./2,DF);

	K=find(tcorr>tvalue);
	SIG(i,:)=zeros(1,length(corrc));
	SIG(i,K)=1;
	
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	Plotting
if PL

K=find(SIG==0);

[LAGS_PL,WID_PL]=meshgrid(lags,WID);
LAGS_SIG=LAGS_PL(K);
WID_SIG=WID_PL(K);
SIG=logical(SIG);

contourf(LAGS_PL,WID_PL,COR,-1:.05:1); shading flat, hold on

CAX=caxis;
caxis(CAX);
[c,h]=contour(LAGS_PL,WID_PL,COR,-1:.05:1,'k');
plot(LAGS_SIG,WID_SIG,'.','color',[.99 .99 .99],'markersize',3.3)
[c,h]=contour(LAGS_PL,WID_PL,COR,-1:.05:1,'linestyle','none');
clabel(c,h,-1:.2:1,'color','k','LabelSpacing',250,'fontsize',11,'rotation',0,'FontWeight','bold');
contour(LAGS_PL,WID_PL,SIG,[1 9999],'color',[.99 .99 .99],'linewidth',2)

xlabel(['Correlation lag [',UNITS,']'])
ylabel(['Low-pass filter width [',UNITS,']'])

%  colorbar_RD('Correlation Coeficient',1)

end

LAG=lags;







