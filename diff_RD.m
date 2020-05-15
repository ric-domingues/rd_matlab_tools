	function T_out=diff_RD(T,Nth)

%  	function T_out=diff_RD(T,Nth)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	Calculates the differential using the Nth spacement
%
%
%		Ricardo Domingues, AOML/NOAA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

T_out=nans(size(T));


for i=Nth+1:length(T)

	T_out(i) = T(i) - T(i-(Nth));

end


