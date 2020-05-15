clc;clear all; close all

time_ref = julian(1993,1,1,0):7:julian(2010,12,31,0); % every 7 days

SIG = randn(1,length(time_ref))/4 + sin(2*pi.*[1:length(time_ref)]./53); %WELL-DEFINED ANNUAL CYCLE

figure
plot(time_ref,SIG);


figure
[WT,time,period,C95,COI] = wavelet_SA(time_ref,SIG,[-1 2],4,1,0); %[-1 2] controla a barra de cores, o CAXIS
ylabel('Periodicity [years]')
colorbar


