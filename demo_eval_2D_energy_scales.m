clc;clear all; close all

load 20040526_sha.mat

figure(100)
pcolor(lon_ref,lat_ref,adt),shading flat
eval_2D_energy_scales(lon_ref,lat_ref,adt,20,1)

%  
%  y=0:.25:60;
%  x=1:.25:60;
%  
%  [x2,y2] = meshgrid(x,y);
%  
%  y_dir = sin(2*pi/20*y)';
%  %  x_dir = ones(1,length(x));
%  x_dir = sin(2*pi/20*x);
%  
%  Z = y_dir*x_dir;
%  
%  %  Z(20:100,1:90) = nan;
%  
%  figure(100)
%  contourf(x2,y2,Z,20),shading flat
%  eval_2D_energy_scales(x2,y2,Z,20,1)
%  %  
