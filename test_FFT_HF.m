clc;clear all; close all;




%  %  
%  %  
%  %  
%  %  Fs = 1000;            % Sampling frequency
%  %  T = 1/Fs;             % Sampling period
%  %  L = 1000;             % Length of signal
%  %  t = (0:L-1)*T;        % Time vector
%  %  
%  %  S = 0.7*sin(2*pi*50*t) + sin(2*pi*120*t);
%  %  X = S;% + 2*randn(size(t));

Fs = 1;            % Sampling frequency
T = 1/Fs;             % Sampling period
L = 1000;             % Length of signal
t = (0:L-1)*T;        % Time vector

S = cos(t*2*pi./48);
X = S;% + 2*randn(size(t));

figure
plot(t,X)
xlabel('t (time units)')
ylabel('X(t)')

Y = fft(X);

P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);


figure
f = Fs*(0:(L/2))/L;
plot(1./f,P1)
title('Single-Sided Amplitude Spectrum of X(t)')
xlabel('period (unit of time)')
ylabel('|P1(f)|')
