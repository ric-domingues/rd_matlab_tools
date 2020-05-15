function RND_var = eval_artificial_predict_RD(Signal,M,N_int,ALPH);
%  function RND_var = eval_artificial_predict_RD(Signal,M,N_int,ALPH);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  		This function provides confidence intervals based on ALPH (default = 0.05) 
%  			for explained variance using multi-variate linear regression method
%  			Based on the concept of artificial predictability
%  				
%  			Ricardo Domingues, AOML/NOAA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Signal(isnan(Signal)) = [];
Signal = stand_RD(Signal);
[NN,MM] = size(Signal);
Y = reshape(Signal,NN*MM,1); 
N = length(Signal);

if(~exist('N_int'))
	N_int = 1000;
end

if(~exist('ALPH'))
	ALPH = 0.05;
end

for i = 1:N_int
	t1 = randn(N,M);

	X = t1;
	A=(inv(X'*X)*X')*Y;
	Y_new = X*A;
	R = corrcoef(Y,Y_new,'rows','complete');
	Corr(i) = R(2);

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Corr_out = sort(Corr);
RND_var = Corr_out(end-round(N_int*ALPH)).^2;
