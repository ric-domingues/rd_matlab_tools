function [MLD,ML_Temp,ML_Salt]=get_profile_MLD(z_prof,t_prof,s_prof,DT);

%  function [MLD,ML_Temp,ML_Salt]=get_profile_MLD(z_prof,t_prof,s_prof,DT);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%		Ricardo Domingues, AOML/NOAA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
MLD=nan;ML_Temp = nan;ML_Salt = nan;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if(~exist('DT'))
  DT=.5;
end  

Dens_prof = sw_dens0(s_prof,t_prof);

Kz = find(abs(z_prof)<=10);
Tsurf = nanmean(t_prof(Kz));
Ssurf = nanmean(t_prof(Kz));

Dsurf = nanmean(Dens_prof(Kz));

DRho = abs(sw_dens0(Ssurf,Tsurf) - sw_dens0(Ssurf,Tsurf+DT));

if(~isnan(DRho) && ~isnan(Dsurf))

    DIFF_t = abs(Dens_prof-Dsurf);

    K_lyr = find(DIFF_t<=DRho);

    MLD = nanmax(abs(z_prof(K_lyr)));    
    ML_Temp = nanmean(t_prof(K_lyr));
    ML_Salt = nanmean(s_prof(K_lyr));    

end

%  plot(Dens_prof,-abs(z_prof))
%  pause

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%