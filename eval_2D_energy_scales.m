function eval_2D_energy_scales(lon,lat,FLD,MAX_WID,PL)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  	This function evaluates the "energy" levels linked with different spatial scales 
%  
%  				lon - 2D field
%  				lat - 2D field		
%				FLD - field to be evaluated (units XX)
%  				MAX_WID - maximum scale to be evaluated
%  				PL - plot "spectrum" if = 1		
%  
%  				Ricardo Domingues, AOML/NOAA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
DX = nanmean(diff(lon(1,:)));
%  WID = round(MAX_WID/DX):-2:1;
WID = 1:2:round(MAX_WID/DX);
[MM,NN] = size(lon);
PERCENT_ENERGY = nan(1,length(WID));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Loops from large scale toward small scales

FLD0 = FLD - nanmean(FLD(:));
MASK = isnan(FLD0);
FLD0(MASK) = 0;

TOTAL_SIGNAL = nanvar(FLD0(:))

FLD_new = FLD0;
FLD_cumul = zeros(MM,NN);

PL2 = 0;

for i=1:length(WID);

	if PL2
	  figure(1),clf
	  imagesc(FLD_new), colorbar; 
	  caxis([-1 1])
	  title('Original')
	end


	FLD_aux = imfilter(FLD_new, ones(WID(i),WID(i)), 'same')./WID(i)^2;
	FLD_eval = FLD_new - FLD_aux;
	FLD_eval(MASK) = 0;
	
	FLD_cumul = FLD_cumul + FLD_eval; 
	VAR_CUMUL(i) = nanvar(FLD_cumul(:));	  	
	
	FLD_new = FLD0 - FLD_cumul;
	FLD_new(MASK) = 0;	
%  	FLD_new = FLD_new - nanmean(FLD_new(:));
	
	if PL2
	  figure(2),clf
	  imagesc(FLD_aux), colorbar;
	  caxis([-1 1])
	  title('Filtered')
	  
	  
	  figure(3),clf
	  imagesc(FLD_eval), colorbar;
	  caxis([-1 1]) 
	  title('Residuo')
	end

end
 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
SCALES = WID.*DX;	
SCALES_DX = SCALES(1:end-1) + diff(SCALES)./2;

figure
plot(SCALES,VAR_CUMUL./TOTAL_SIGNAL), hold on
plot(SCALES_DX,diff(VAR_CUMUL./TOTAL_SIGNAL))
%  ylim([0 1])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%








