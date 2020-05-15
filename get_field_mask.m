function MASK_out = get_field_mask(lon,lat);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%  This function retrieves a Land Mask and for boundaries given lon and lat
%  			
%		NOTE: lon and lat are 2D matrices
%    
%  		Ricardo Domingues, AOML/NOAA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Z = get_bathy2grid(lon,lat);
[MM,NN] = size(lon);

MASK_out = ones(MM,NN);
Cont = find(Z>-5);

MASK_out(Cont) = 0;
MASK_out(1,:) = 0;
MASK_out(end,:) = 0;
MASK_out(:,1) = 0;
MASK_out(:,end) = 0;

MASK_out = logical(MASK_out);


