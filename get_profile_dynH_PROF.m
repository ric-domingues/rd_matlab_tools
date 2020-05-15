function [DYNH]=get_profile_dynH_PROF(lon,lat,press,temp,salt,P_REF);

%  [DYNH,SATDYNH,IPRC_bottom,MDT]=get_profile_dynH(date,lon,lat,press,temp,salt,P_REF);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  	This function calculates the ABSOLUTE dynamic height based on TS 
%  		profiles and on MDT_CNES_09
%  	It also outputs the satellite derived ABSOLUTE dynamic topography 
%  		for comparison
%  				
%  		P_REF = reference pressure
%  
%  		Ricardo Domingues, AOML/NOAA, 2012
%   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  initial configurations

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Getting IPRC to profile 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Getting profile DYNH

DZ = 1;%m

for i=1:length(lon)

	T1 = temp(:,i); 
	S1 = salt(:,i);
	P1 = press(:,i);

	K=find(S1<30 | S1>40);
	T1(K)=[];
	S1(K)=[];
	P1(K)=[];

	K=isnan(T1);
	T1(K)=[];
	S1(K)=[];
	P1(K)=[];

	K=isnan(S1);
	T1(K)=[];
	S1(K)=[];
	P1(K)=[];

	P_REF = nanmax(P1);

	P_i = 1:DZ:P_REF;
	
	MAXP=nanmax(P_i(:));
	
	[P1,I]=unique(P1);
	T1=T1(I);
	S1=S1(I);

	if(length(P1)>10)

		T2=interp1(P1,T1,P_i);
		S2=interp1(P1,S1,P_i);
	else
		S2=[];
		P_i=1;
	end
	
%  	figure(1),clf
%  	plot(S2,P_i);
%  	pause

	if(~(isempty(P_i) || isempty(MAXP) || isempty(S2)) && length(P_i)>40)

%  		SH = gsw_steric_height(S2,T2,P_i,MAXP);
%  		dynH(i) = SH(1);
		SVAN = sw_svan(S2,T2,P_i);
		Dens0 = sw_dens(ones(length(T2),1).*35,ones(length(T2),1).*0,P_i');
		dynH(i) = DZ.*nansum(SVAN'.*Dens0)*9.8/10;

	else	
		dynH(i) = nan;
	end
end

DYNH=dynH*100;
