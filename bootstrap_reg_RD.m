function [A,ERR,SIG,YNEW]=bootstrap_reg_RD(X,Y,NINT,ALPH);

%  function [A,ERR,SIG]=bootstrap_reg_RD(X,Y,NINT,ALPH);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  	This function applies a multi-variate linear regression to estimate 
%  		slope coefficients for the model:
%  
%			Y = A*X;  	
%  
%  			Y is a single column vector
%  			X is a nxm matrix (n is time, m number of variables)
%  
%  
%  			Ricardo Domingues, AOML/NOAA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[n,m] = size(X); 
if(~exist('ALPH'))
	ALPH = 0.05;
end

if(~exist('NINT'))
	NINT = 1000;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i=1:NINT % BOOT-STRAP INTERACTIONS
	
	n_use = round(1/3*n);
	I_BOOTS = floor(rand(n_use,1)*n)+1;
	a_aux=(inv(X(I_BOOTS,:)'*X(I_BOOTS,:))*X(I_BOOTS,:)')*Y(I_BOOTS);
	A_coeffs(:,i) = a_aux;
end

LIM_inf = round(ALPH*NINT/2);
LIM_sup = NINT - round(ALPH*NINT/2);
A_coeffs = sort(A_coeffs,2);

ERR = (A_coeffs(:,LIM_sup) - A_coeffs(:,LIM_inf))./2;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
A=(inv(X'*X)*X')*Y;

SIG = zeros(size(A));

SIG(find(abs(A)-ERR>0)) = 1;
SIG = logical(SIG);

YNEW = X*A;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




