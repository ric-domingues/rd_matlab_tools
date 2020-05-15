clc;clear all; close all;

t = 1:5000;

x = cos(2*pi/365*t) + sin(2*pi/180*t); 
y = x + rand(1,length(t))*3;     % Sinusoids plus noise

[period,POWER]=fft_RD(t,y,1);