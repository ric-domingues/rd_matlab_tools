function XSMO = rmean_2D(X,W);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%	This function apply a running mean filter on X (2D), based on the window W
%		
%		W must be a odd number
%
%		Ricardo M. Domingues AOML/NOAA, November 4, 2011
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

WID = round((W-1)/2);

[m,n]=size(X);
mask = isnan(X);
XSMO = nan(m,n);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i=1:m
	if(i<WID+1)
		INT_i = [1:i+WID];
	elseif(i>m-(WID))	
		INT_i = [i-WID:m];
	else
		INT_i = [i-WID:i+WID];
	end

	for j=1:n

		if(j<WID+1)
			INT_j = [1:j+WID];
		elseif(j>n-(WID))	
			INT_j = [j-WID:n];
		else
			INT_j = [j-WID:j+WID];
		end
		
		AUX = X(INT_i,INT_j);		
		XSMO(i,j) = nanmean(AUX(:));
	end
end

XSMO(mask)=nan;
