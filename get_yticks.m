function set_yaxis(T1,Nticks);

YMEAN = nanmean(T1);


YMIN = nanmin(T1);
[INT,MAG]=ext_magnitude(YMIN)
YMIN = floor(INT)*MAG;


YMAX = nanmax(T1);
YMAX = ceil(INT)*MAG;

if(isint((YMAX-YMIN)/(Nticks-1)))

	YLIM = linspace(YMIN,YMAX,Nticks);

else
	BLOCKS = round((YMAX-YMIN)/(Nticks-1)); 
	

	























