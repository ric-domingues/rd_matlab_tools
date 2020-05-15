function [IsoTLYR_Depth,IsoTLYR_Temp]=get_profile_Isothermal_Layer(z_prof,t_prof,DT);

%  function [TCHP]=get_profile_tchp(z_prof,t_prof);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%		Ricardo Domingues, AOML/NOAA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
IsoTLYR_Depth=nan;IsoTLYR_Temp = nan;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if(~exist('DT'))
  DT=.5;
end  

Kz = find(abs(z_prof)<5);
T_ref = nanmean(t_prof(Kz));

if(~isnan(T_ref))

    DIFF_t = abs(t_prof-T_ref);

    K_lyr = find(DIFF_t<=DT);

    IsoTLYR_Depth = nanmax(abs(z_prof(K_lyr)));
    IsoTLYR_Temp = nanmean(t_prof(K_lyr));

end

%  plot(DIFF_t,-abs(z_prof))
%  pause

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%