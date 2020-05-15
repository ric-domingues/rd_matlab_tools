function [vtrends,utrends,VEL_trends,SIG_trends] = get_wind_trends(time_GMT,U,V);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%	This function retrieves the SHA time-series for P1 and P2
%
%		Ricardo M. Domingues AOML/NOAA
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[m,n,k] = size(U)

vtrends=nan(m,n);
utrends=nan(m,n);
VEL_trends=nan(m,n);
SIG_trends=zeros(m,n);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%	

U_aux = squeeze(U(:,:,1));
MASK = isnan(U_aux);

whos MASK

VEL = sqrt(U.^2 + V.^2);

for i=1:m
i
	for j=1:n
		if(MASK(i,j)==0);
		
			u_aux = squeeze(U(i,j,:));
			
			[utrend_aux,SIG_u,ERR,X,Y]=get_trend(time_GMT,u_aux,0.1,0); % degC/year
			utrends(i,j) = utrend_aux;
			
			v_aux = squeeze(V(i,j,:));						
			[vtrend_aux,SIG_v,ERR,X,Y]=get_trend(time_GMT,v_aux,0.1,0); % degC/year			
			vtrends(i,j) = vtrend_aux;
			
			vel_aux = squeeze(VEL(i,j,:));	
			[veltrend_aux,SIG_vel,ERR,X,Y]=get_trend(time_GMT,vel_aux,0.1,0); % degC/year			
			VEL_trends(i,j) = veltrend_aux;
			
                        SIG_trends(i,j) = SIG_u+SIG_v+SIG_vel;			
		end
	end


end
