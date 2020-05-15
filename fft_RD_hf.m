function [period,POWER]=fft_RD_hf(time,ts,Fs,PL);

%  function [period,POWER]=fft_RD(time,ts,PL);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
%  	This function calculates the FFT for the time-series entered
%  		
%  		time = reference time vector
%		ts = time-series/signal to process   
%  		Fs = sampling frequency (samples/unit of time)
%  
%  		NOTE: 	-sampling resolution = 1sample/day
%  			-NaNs are filled with fillnans_RD
%  			-see demo_fft_RD.m
%   
%  			Ricardo Domingues AOML/NOAA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
period=nan;POWER=nan;
if(~exist('PL'))
	PL=1;
end

K = isnan(ts);
ts(K)=[];
time(K)=[];
ts=ts-nanmean(ts(:));

%  Fs = 1;            % Sampling frequency
T = 1/Fs;             % Sampling period
L = length(ts);             % Length of signal
%  t = (0:L-1)*T;        % Time vector

%  S = ts;
X = ts;% + 2*randn(size(t));


Y = fft(X);

P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);

f = Fs*(0:(L/2))/L;

if PL

figure
subplot(2,1,1)
plot(time,X)
xlabel('t (time units)')
ylabel('X(t)')

subplot(2,1,2)
plot(1./f,P1)
title('Single-Sided Amplitude Spectrum of X(t)')
xlabel('period (unit of time)')
ylabel('|P1(f)|')

end

POWER=P1;
period=1./f;
