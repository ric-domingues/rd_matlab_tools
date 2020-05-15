function [R,Psig,P_coeffs]=robust_regress_RD(X,Y,WID,STEP,XPEC_SIGN);

R=nan;Psig=nan;P_coeffs=nan;

X_use = X;
Y_use = Y;

K = isnan(X_use);
X_use(K) = [];
Y_use(K) = [];

K = isnan(Y_use);
X_use(K) = [];
Y_use(K) = [];


MAT = [X_use,Y_use];

[EOFs,PCs,EXPVAR]=caleof(MAT,2,1);

EXPVAR

MAT2 = (EOFs*PCs)';


figure
plot(MAT)


figure
plot(-MAT2)




whos MAT*



return

% ========================================================================================





L = length(X_use);

% ========================================================================================
%  Creating field

N_INTERACTIONS = length([WID+1:STEP:L])

Slope_ALL = nan(1,N_INTERACTIONS);
Intercept_ALL = nan(1,N_INTERACTIONS);
R_ALL = nan(1,N_INTERACTIONS);

% ========================================================================================
%  PRELIMINARY

[R,Psig,P]= plot_fit(X_use,Y_use);
close all;


[V,SIG,ERR,X_lin,Y_lin]=get_trend(X_use,Y_use,0.05,0);


Y_synth1 = polyval(P,X);

% ========================================================================================
%  INTERACTION

c = 0;
for i=[WID+1:STEP:L]
  c=c+1;

    X_SAMP = X_use(i-WID:i);
    Y_SAMP = Y_use(i-WID:i);
    
    P = polyfit(X_SAMP,Y_SAMP,1);    
    
    Slope_ALL(c) = P(1);
    Intercept_ALL(c) = P(2);    

    R = corrcoef(X_SAMP,Y_SAMP);
    
    R_ALL(c) = R(1,2);   
    
    Y_aux = polyval(P,X);   
    
    RMSE_all(c) = sqrt(nanmean(Y_aux-Y).^2);
    
    
end
% ========================================================================================
%  SORTING DATA


%  [RMSE_sorted,I_RMS] = sort(RMSE_all);
%  Slope_sort = Slope_ALL(I_RMS);
%  Intercept_sort = Intercept_ALL(I_RMS);
%  
%  P_coeffs = [Slope_sort(1) Intercept_sort(1)]



[R_sorted,IR]=sort(R_ALL);
Slope_sort = Slope_ALL(IR);
Intercept_sort = Intercept_ALL(IR);


if(XPEC_SIGN<0)

    [ PERC95 ] = percentile_RD(-R_sorted,90)*-1;
    
    Kperc = find(R_sorted<PERC95);
    
    P_coeffs = [nanmean(Slope_sort(Kperc)) nanmean(Intercept_sort(Kperc))]

end


Y_synth2 = polyval(P_coeffs,X);

X_lin2 = [nanmin(X) nanmax(X)];
Y_lin2 = X_lin2.*P_coeffs(1) + P_coeffs(2);


figure(100)
plot(Y,'b','linewidth',2), hold on
plot(Y_synth2,'k','linewidth',2)
plot(Y_synth1,'r','linewidth',2)

figure(1)
plot(X,Y,'k*'), hold on
plot(X_lin,Y_lin,'b','linewidth',3)
plot(X_lin2,Y_lin2,'r','linewidth',3)


figure
plot_fit(Y_synth2,Y);

