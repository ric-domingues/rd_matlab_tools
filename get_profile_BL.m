function [BLT,BLPE]=get_profile_BL(z_prof,t_prof,s_prof,MLD,IsoTLYR_Depth);

%  function [BLT,BLPE,ML_Salt]=get_profile_BL(z_prof,t_prof,s_prof,DT);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%		Ricardo Domingues, AOML/NOAA
%  			
%      			This function computes the barrier layer thickness, and potential energy from (Chi et al., 2014)
%    
%  
%  			BLT = is in meters
%  
%  			BLPE = is in kJ / m2
%  
%    			Chi, N. H., Lien, R. C., D'Asaro, E. A., & Ma, B. B. (2014). The surface mixed layer heat budget from 
%  			mooring observations in the central Indian Ocean during Madden–Julian oscillation events. Journal of 
%  			Geophysical Research: Oceans, 119(7), 4638-4652.
%    
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
BLT=nan;BLPE = nan;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dz=1;
z_ref = 0:dz:nanmax(abs(z_prof));
Dens_prof = sw_dens0(s_prof,t_prof);

DENS_use = interp1(abs(z_prof),Dens_prof,z_ref);
T_use = interp1(abs(z_prof),t_prof,z_ref);
S_use = interp1(abs(z_prof),s_prof,z_ref);

%  figure
%  plot(DENS_use,-z_ref)
%  
%  figure
%  plot(s_prof,-z_prof)
%  
%  figure
%  plot(t_prof,-z_prof)
%  pause

g = 10;%gravity
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if(~isnan(MLD) && ~isnan(IsoTLYR_Depth) && abs(IsoTLYR_Depth)>abs(MLD))

    BLT = IsoTLYR_Depth - MLD;
    
    if(BLT>0)
%  ------------------------------------------------
%   POTENTIAL ENERGY

	KzMLD = find(z_ref<=MLD);
	
	KzIST_MLD_diff = find(z_ref>MLD & z_ref<=IsoTLYR_Depth) ;
	
	Rho_MLD = nanmean(DENS_use(KzMLD));
	P01 = ( 1/2 * Rho_MLD * MLD^2 );
		
	Rho_IST_n_MLD = nanmean(DENS_use(KzIST_MLD_diff));
	
	P02 = ( 1/2 * Rho_IST_n_MLD * (IsoTLYR_Depth^2-MLD^2) );
	PE0 = -g * (P01 + P02);
	    
    %  ------------------------------------------------
    %   POTENTIAL ENERGY MIX    

	KzIST = find(z_ref<=IsoTLYR_Depth);

	DENS_mix = sw_dens0(nanmean(S_use(KzIST)),nanmean(T_use(KzIST)));	
	
	PEMIX = -g * 0.5 * DENS_mix * IsoTLYR_Depth^2;

    %  ------------------------------------------------
    %   Barrier Layer Potential Energy
      
	BLPE = (PEMIX - PE0)./1000; % kJ / m2
    end
    
else
	BLPE = 0;
end

%  J = kg . m2 . s-2

%  J / m2 = kg . s-2


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%