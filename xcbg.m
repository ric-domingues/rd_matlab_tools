function [ccxy,gain,st,tau,dof] = Xcbg(lag,x,y)
%Function [ccxy,gain,st,tau,dof] = Xcbg(lag,x,y)
%  Calculates the biased crosscorrelation function of x & y,
%  from -Lag to +Lag. Autocorrelation is computed when x = y or y is missing.
%    
%  x & y must be equally dimensioned column vectors.
%  On output, ccxy = [lags,cf], where cf is the correlation function and
%  lags = -lag : lag.  y lags x for positive lags. Gain vector is also returned
%  as gain = [lags,g].
%
%  The large-lag standard error (st) is an option estimated by sterdof.
%  The independence time scale in intervals (tau) and degrees of freedom (dof) 
%  are returned as well.
%  
%  The estimated 90%, 95%, 99% significance levels for ccxy are
%  correspondingly estimated as 1.7*st, 2.0*st and 2.6*st.
%
%  Notes: 
%  1) Data are assumed to have been preconditioned in that all are valid.
%  2) Computing st takes more time than ccxy. In repetitive use,
%     it may be better to not request st as output, and make 
%     a separate estimate using sterdof with representative data samples. 
%
%  Makes calls to mean, std, xcorr and sterdof(optional for > than 2 input 
%  arguments).

%  Normalize and preserve inputs.
[m,n] = size(x);
	if nargin < 3 
y = x; xdm = x-mean(x); ydm=xdm;
varx = (xdm)'*(xdm)/m; sigx = sqrt(varx); vary = varx; sigy = sigx;
	else
xdm = x-mean(x); ydm=y-mean(y);
varx = (xdm)'*(xdm)/m; sigx = sqrt(varx);
vary = (ydm)'*(ydm)/m; sigy = sqrt(vary);
	end

% Compute the outputs. 
xc=xcorr(xdm,ydm,'biased'); %covariance xc has length 2*m-1.
lags = -lag:1:lag; 
xcv = xc((m-lag):(m+lag)); %xcv has length 2*lag+1.
cf = xcv/(sigx*sigy);
g = xcv/varx;
ccxy = [lags',cf]; %ccxy has length 2*lag+1.
gain = [lags',g];  %gain has length 2*lag+1.
if nargout > 2; [st,tau,dof] = sterdof(x,y); end

