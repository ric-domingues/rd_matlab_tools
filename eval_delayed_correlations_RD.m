function [Lags_OUT,Corr_OUT]=eval_delayed_correlations_RD(Corr,x2,y2,X0,Y0,MAXLAG,N,PERC,RAD_DX,CMASK);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  
%  
%  
%  
%  
%  
%  
%  
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if(~exist('RAD_DX'))
  RAD_DX=1;
end

if(~exist('CMASK'))
  CMASK = ones(size(x2));
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

DX = sqrt((x2-X0).^2 + (y2-Y0).^2);
DXmax = nanmax(DX(:));
DX_N = linspace(0,DXmax,N);
LAGS_N = linspace(0,MAXLAG,N);

[mm,nn]=size(x2);
Corr_OUT= nan(mm,nn);
Lags_OUT=nan(mm,nn);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
DXbase = 0

for k=1:N
    k

    [I,J] = find(DX>=DXbase & DX<=DX_N(k));
    DXbase = DX_N(k);
      
    LAG_all = [];
    cc=0;
    for n=1:length(I);          
    
      if( CMASK(I(n),J(n)) )
	cc=cc+1;
	if(cc==1)      
	  LAG_0 = 0;
	else
	  resp=0;
	  cresp=0;
	  while(resp==0)
	    XX2=x2(I(n),J(n));
	    YY2=y2(I(n),J(n));
	    DX2 = sqrt((x2-XX2).^2 + (y2-YY2).^2);      
	    IND_DX2 = find(DX2<=RAD_DX+cresp);
	    LAG_0 = nanmean(Lags_OUT(IND_DX2));
	    if(isnan(LAG_0))
	      cresp=cresp+1;
	    else
	      resp=1;
	    end
	    
	  end  
	 
	  
	end      

	LAG_max = LAG_0 + MAXLAG*PERC;
	LAG_min = LAG_0 - MAXLAG*PERC;
	      
	LAGS_aux = squeeze(Corr.lags(I(n),J(n),:));
	Corr_aux = squeeze(Corr.coef(I(n),J(n),:));
	
	IND_lag = find(LAGS_aux>=0 & LAGS_aux>=LAG_min & LAGS_aux<LAG_max);                  
	
	LAGS_aux = LAGS_aux(IND_lag);
	Corr_aux = Corr_aux(IND_lag);
	
	[aux,IND_cor] = nanmax(abs(Corr_aux));
	
	Corr_OUT(I(n),J(n)) = Corr_aux(IND_cor);
	Lags_OUT(I(n),J(n)) = LAGS_aux(IND_cor);      
	
  %        LAG_all(cc) = LAGS_aux(IND_cor);

      end
      
   end

%     LAG_0 = nanmean(LAG_all);
      
end
   