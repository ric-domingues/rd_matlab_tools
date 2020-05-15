clc;clear all;close all

M = 100;
N = 1000;

time = 1:N;% days
Signal = sin(2*pi/60*time).*rand(1,N);

RND_var = eval_artificial_predict_RD(Signal,M,1000,0.05);







