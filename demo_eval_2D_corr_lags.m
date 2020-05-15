clc; clear all; close all; warning off

MAXLAG = 60 %weeks
WID = 3:3:43;


time=1:900; %weeks
teta0=2*pi/250;
Lag0 = 13; %weeks

Forc = sin(teta0*time);
Forc([1:250,375:end])=0;

%  ts1 = sin(teta0*time + Lag0*teta0);
ts1 = zeros(size(Forc));
ts1(1:end-Lag0+1)=Forc(Lag0:end);


plot(time,Forc), hold on
plot(time,ts1,'r');

figure
[COR,WID,LAG,SIG] = coherence2D_RD(Forc,ts1,WID,MAXLAG,0.05,1);

x_ref = -30:30;
y_ref = -40:40;

[x2,y2]=meshgrid(x_ref,y_ref);
[m,n]=size(x2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Generating LAGS
X0 = 0;
Y0 = 0;

Lags = nan(m,n);

for i=1:m
  for j=1:n  
	Lags(i,j) = (sqrt((x2(i,j)-X0).^2 + (y2(i,j)-Y0).^2));                
   end    
end

Lags(1:10,:) = 0;

for i=1:m
  for j=1:n
%  	Tseries(i,j,:) = sin(teta0*time +  Lags(i,j)*teta0);      
	t_aux = zeros(size(Forc));
	t_aux(1:end-Lags(i,j))=Forc(Lags(i,j)+1:end);
	Tseries(i,j,:) = t_aux;    
   end    
end


figure
pcolor(x2,y2,Lags),shading flat, caxis([0 50]), colorbar

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Function

MAXLAG = 60 %weeks
PERCENT = 10/100;
N = 30; %number of concentric circles;

Corr_OUT = nan(m,n);
Lags_OUT = nan(m,n);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  %  %  Step 1: getting the matrix of correlation coefficients

%  for i=1:m
%    i
%    for j=1:n
%    
%  	T_use = squeeze(Tseries(i,j,:))';
%  	
%      	[max_ccx, max_lag, corrc, lags, significance_90] =  check_corr5_RD(Forc',T_use','te','et',MAXLAG,0);  
%      	
%  	Corr.coef(i,j,:) = corrc;
%  	Corr.lags(i,j,:) = lags;
%      	  
%    end  
%  end
%  
%  save Corr_demo Corr

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Generating the propagation signal
load Corr_demo

MAXLAG = 60 %weeks
PERCENT = 30/100;
N = 50; %number of concentric circles;

[Lags_OUT,Corr_OUT]=eval_delayed_correlations_RD(Corr,x2,y2,X0,Y0,MAXLAG,N,PERCENT,3);
%  
   
figure
pcolor(x2,y2,Lags_OUT), shading flat, caxis([0 50]), colorbar
   
   
   