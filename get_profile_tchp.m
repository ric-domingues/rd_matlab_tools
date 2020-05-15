function [TCHP,D26]=get_profile_tchp(z_prof,t_prof);

%  function [TCHP]=get_profile_tchp(z_prof,t_prof);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%		Ricardo Domingues, AOML/NOAA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
TCHP=nan;D26 = nan;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cp = 3990;%kg m^-3
rho=1025;%J kg^-1 degC^-1
Jm2tokJcm2 = 1e7; %conversion factor for units. final values are in kJ/cm2

knan = isnan(t_prof);
t_prof(knan) =[];
z_prof(knan) =[];

if(nanmin(abs(z_prof))<50 && length(z_prof>10))

  z_USE = 0:1:nanmax(abs(z_prof));
  t_prof = inpaint_nans(t_prof,5);

  t_USE = interp1(abs(z_prof),t_prof,z_USE);

  K26 = find(t_USE>=26);
  D26 = nanmax(z_USE(K26));

  AUX = nansum(t_USE(K26)-26);

  TCHP = AUX.*cp.*rho./Jm2tokJcm2;

end  


if(nanmax(abs(t_prof))<26)	

  D26 = NaN;
  TCHP = 0;

elseif(nanmin(abs(t_prof))>26)
  D26 = NaN;
  TCHP = NaN;
	
end  
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%