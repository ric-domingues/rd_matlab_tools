function XSMO = rmean(X,W);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%	This function apply a running mean filter on X, based on the window W
%		
%		W must be a odd number
%
%		Ricardo M. Domingues AOML/NOAA, November 4, 2011
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

XSMO = nan(size(X));
WID = round((W-1)/2);

m=length(X);

for i=1:m

	if(i<WID+1)
		INT_i = [1:i+WID];
	elseif(i>m-(WID))	
		INT_i = [i-WID:m];
	else
		INT_i = [i-WID:i+WID];
	end

	XSMO(i) = nanmean(X(INT_i)');

end
