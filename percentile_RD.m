function [ q_k ] = percentile_RD( x, kpercent )

% STEP 1 - rank the data
y = sort(x);
Nx = length( x );


% STEP 2 - find k% (k /100) of the sample size, n.
k = kpercent/100;
IDper = round(k*Nx);

q_k = y(IDper);
