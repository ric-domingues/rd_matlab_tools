function GEM = get_GEM(T,S,Z,dynH,N,PL,SMOO);

%  function GEM = get_GEM(T,S,dynH);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  	This function generates a Gravest Empirical Mode based on TS Vs. dynH data
%			
%			T - temperature profiles as T(z,x)
%			S - salinity profiles as S(z,x)
%			dynH - dynamic height as dynH(x)
%			N - length of output GEM
%			PL = 1 - plot output GEM
%			SMO = number of smoothn 
%
%  		Ricardo Domingues, AOML/NOAA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
warning off

if(~exist('PL'))
	PL=0;
end

if(~exist('SMOO'))
	SMOO=0;
end

[dynH,I]=sort(dynH);

T = T(:,I);
S = S(:,I);

%  figure
%  pcolor(dynH,-Z,T),shading flat
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Generating the GEM

dynH_ref = linspace(nanmin(dynH),nanmax(dynH),N);

DH = diff(dynH_ref);
DH(2:end+1)=DH;
DH(1)=0;
DH(end+1)=0;
DH=DH/2;

c=0;
for i = 1:length(dynH_ref);

	I = find(dynH>=(dynH_ref(i)-DH(i)) & dynH<=(dynH_ref(i)+DH(i+1)));

	if(~isempty(I))
		c=c+1;		
		GEM.T(:,c) = nanmean(T(:,I),2);
		GEM.Tstd(:,c) = nanstd(T(:,I),1,2);
		
		GEM.S(:,c) = nanmean(S(:,I),2);
		GEM.Sstd(:,c) = nanstd(S(:,I),1,2);
		GEM.dynH(c) = nanmean(dynH(I));
	end

end

GEM.Tstd = (GEM.Tstd)./nanmax(GEM.Tstd(:));
GEM.Sstd = (GEM.Sstd)./nanmax(GEM.Sstd(:));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% QC ON SALINITY
%  length(GEM.dynH)

K=find(GEM.S<33.5 | GEM.S>37);
GEM.S(K)=nan;
GEM.S = inpaint_nans(GEM.S,5);

[I,J]=find(GEM.Sstd>0.6);
GEM.S(:,J)=[];
GEM.T(:,J)=[];
GEM.Sstd(:,J)=[];
GEM.Tstd(:,J)=[];
GEM.dynH(J)=[];

%  length(GEM.dynH)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Smoothing

if (SMOO>0)
	for i=1:SMOO
		GEM.T = smo(GEM.T);
		GEM.S = smo(GEM.S);
	end
	
	dynH_aux = GEM.dynH; 
 	dynH_aux = (dynH_aux-nanmean(dynH_aux))*.85 + nanmean(dynH_aux);
	GEM.dynH = dynH_aux;
end
[m,n]=size(GEM.T);

for i=1:n

	GEM.T(:,i) = inpaint_nans(GEM.T(:,i),5);
	GEM.S(:,i) = inpaint_nans(GEM.S(:,i),5);
end

GEM.Z = Z;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plotting

if PL
close all

figure(173)
P=auto_plot(1,2,1,.1,.7,.6,.6,7,6);

pcolor(GEM.dynH,-Z,GEM.Tstd); shading interp
xlabel('dynamic height [dyn m]')
ylabel('depht')
POS = get(gca,'position');
cb = colorbar;
set(cb,'position',[.93 .09 .02 .3])
set(gca,'position',POS)
title(cb,'std')

set(gca,'handlevisibility','off')
set(gca,'handlevisibility','off')

pcolor(GEM.dynH,-Z,GEM.T); shading interp
xlabel('dynamic height [dyn m]')
ylabel('depht')
POS = get(gca,'position');
cb = colorbar;
set(cb,'position',[.93 .545 .02 .3])
set(gca,'position',POS)
title(cb,'[^oC]')
title('\bf GEM - Temperature')

figure(174)
P=auto_plot(1,2,1,.1,.7,.6,.6,7,6);

pcolor(GEM.dynH,-Z,GEM.Sstd); shading interp
xlabel('dynamic height [dyn m]')
ylabel('depht')
POS = get(gca,'position');
cb = colorbar;
set(cb,'position',[.93 .09 .02 .3])
set(gca,'position',POS)
title(cb,'std')

set(gca,'handlevisibility','off')
set(gca,'handlevisibility','off')

pcolor(GEM.dynH,-Z,GEM.S); shading interp
xlabel('dynamic height [dyn m]')
ylabel('depht')
POS = get(gca,'position');
cb = colorbar;
set(cb,'position',[.93 .545 .02 .3])
set(gca,'position',POS)
title(cb,'salt')
title('\bf GEM - Salinity')

end





	




