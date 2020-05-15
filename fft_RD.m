function [period,POWER]=fft_RD(time,ts,PL);

%  function [period,POWER]=fft_RD(time,ts,PL);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
%  	This function calculates the FFT for the time-series entered
%  		
%  		time = reference time vector
%		ts = time-series/signal to process   
%  
%  		NOTE: 	-sampling resolution = 1sample/day
%  			-NaNs are filled with fillnans_RD
%  			-see demo_fft_RD.m
%   
%  			Ricardo Domingues AOML/NOAA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
if(~exist('PL'))
	PL=1;
end
time_ref = time(1):1:time(end);
ts_i = interp1(time,ts,time_ref);

ts_filled = fillnans_RD(ts_i);

Fs = 365;                    % Sampling frequency (samples/year)
T = 1/Fs;                    % Sample time
L = length(time_ref);        % Length of signal (days)
t = 1:L;             	     % Time vector (days)
% Sum of a 50 Hz sinusoid and a 120 Hz sinusoid
y = ts_filled;     % Sinusoids plus noise

NFFT = 2^nextpow2(L); % Next power of 2 from length of y
Y = fft(y,NFFT)/L;
f = Fs/2*linspace(0,1,NFFT/2);
P=1./f;
POWER= 2*abs(Y(1:NFFT/2));
POWER = rmean(POWER,3);
period = P;

% Plot single-sided amplitude spectrum.

if(PL)
figure
subplot(2,1,1)
plot(t,y,'k')
xlabel('time (days)')

subplot(2,1,2)
plot(P,POWER) 
title('Single-Sided Amplitude Spectrum of y(t)')
xlabel('Period [year]')
ylabel('|Y(f)|')
xlim([0 4])

end

