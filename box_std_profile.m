function [T,Z] = box_std_profile(t,z,DZ,MAXDEPTH);

%  function [T,Z] = box_average_profile(t,z,DZ);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 		Ricardo Domingues, AOML/NOAA 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

T=nan;
Z=nan;
z=abs(z);

if(~exist('MAXDEPTH'))
	MAXDEPTH=nanmax(z);
end

Z = 0:DZ:MAXDEPTH;

for k=1:length(Z)

	INDz = find(z>=Z(k)-DZ/2 & z<Z(k)+DZ/2);
	T(k) = nanstd(t(INDz));
end
	

	







