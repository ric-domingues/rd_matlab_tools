function	min_coeff = min_sig_coeff_RD(DF,ALPH);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  	This functions uses a double tail t-table to evaluate 
%  		the minimum significant correlation coeff
%		at sig level ALPHA (default = 0.05)  
%  	
%		min_coeff = absolute coefficient
%  
%  		Ricardo Domingues, AOML/NOAA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if(~exist('ALPH'))
	ALPH=0.05;
end

tvalue = t_table(ALPH./2,DF);
min_coeff = tvalue./sqrt(DF + tvalue.^2);