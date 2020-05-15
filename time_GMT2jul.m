function time_jul=time_GMT2jul(time_GMT)
%  function time_GMT=time_jul2GMT(time_ref)
%  Transform dates into decimal years

time_jul = nan;

for i = 1:length(time_GMT)

	YR_base = floor(time_GMT(i));
	NDAYs = julian(YR_base+1,1,1,0) - julian(YR_base,1,1,0);

	DAY_i = (time_GMT(i) - YR_base)*NDAYs;

	time_jul(i) = julian(YR_base,1,DAY_i,0);

end
