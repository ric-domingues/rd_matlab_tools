function T1_new = correct_freqband_amplitude(T1,T2,BANDS);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  			BANDS =   (sampling frequency units)
%  			
%  			0    20
%  			20    40
%  			40    60
%  			60    80
%  			80   100
%  			100   120
%  			120   140
%  			140   160
%  			160   180
%  
%  				Ricardo Domingues, AOML/NOAA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

T1_0=T1;
T2_0=T2;

T1=T1-nanmean(T1_0);
T2=T2-nanmean(T2_0);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[m,n] = size(BANDS);

for i=1:m
	F1=BANDS(i,1);
	F2=BANDS(i,2);

	if(F2>0)	
		T1_aux=rmean_hf(T1,F2);
		T2_aux=rmean_hf(T2,F2);
	else
		T1_aux=T1;
		T2_aux=T2;		
	end

	if(F1>0)	
		T1_aux=rmean(T1_aux,F1);
		T2_aux=rmean(T2_aux,F1);
	else
		T1_aux=T1_aux;
		T2_aux=T2_aux;		
	end

	T1_aux = T1_aux - nanmean(T1_aux);
	T2_aux = T2_aux - nanmean(T2_aux);

	PP = splinefit(T1_aux,T2_aux,1);
	
	COMP(i,:) = ppval(PP,T1_aux);

end

T1_new = nansum(COMP,1) + nanmean(T2_0);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%















%  clc;clear all;close all
%  
%  x=0:1:3000;
%  
%  MAXLAG=370;
%  WID=0:50:1500; 
%  
%  T1 = 2*sind(x);
%  T2 = sind(x);
%  
%  plot(x,T1), hold on
%  
%  plot(x,T2,'r')
%  
%  %  figure
%  %  [COR,WID,LAG,SIG] = coherence2D_RD(T1,T2,WID,MAXLAG,0.05,1,'days');
%  
%  PP=splinefit(T1,T2,1);
%  T1_new = ppval(PP,T1); 
%  
%  plot(x,T1_new,'k')
%  
%  
%  
%  BANDS=[0:20:340' 20:20:360']
