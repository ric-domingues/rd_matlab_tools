function [T,Z] = box_average_profile(t,z,DZ,MAXDEPTH);

%  function [T,Z] = box_average_profile(t,z,DZ);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 		Ricardo Domingues, AOML/NOAA 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

T=nan;
Z=nan;
z=abs(z);

[z,Iz] = sort(z);
t = t(Iz);

if(~exist('MAXDEPTH'))
	MAXDEPTH=nanmax(z);
end

Z = 0:DZ:MAXDEPTH;

T = nan(length(Z),1);

for k=1:length(Z)

	INDz = find(z>=Z(k)-DZ/2 & z<Z(k)+DZ/2);
	
	if(~isempty(INDz));	
	  T(k) = nanmean(t(INDz));
    end  	  
end
	






