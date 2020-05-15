clc;clear all; close all;


z = 1:100;

t = 28*ones(size(z));

s = 36*ones(size(z));

s(z<40) = 35.99;

figure
plot(t,-z)

figure
plot(s,-z)

MLD = 40;
IST = 100;

[BLT,BLPE]=get_profile_BL(z,t,s,MLD,IST);




%------------------------------------------------------------
%------------------------------------------------------------
%  Reference Calculation
g=10

Rho_MLD = sw_dens0(nanmean(s(z<40)),nanmean(t(z<40)));

Rho_IST_n_MLD = sw_dens0(nanmean(s(z>40)),nanmean(t(z>40)));


PE0_ref = -g *( ( 1/2 * Rho_MLD * MLD^2 )  + ( 1/2 * Rho_IST_n_MLD * (IST^2-MLD^2) ) )

Rho_MIX = sw_dens0(nanmean(s),nanmean(t));

P0MIX_ref = -g * 1/2 * Rho_MIX * IST^2

BLPE_ref = (P0MIX_ref - PE0_ref)

