function [ ret ] = get_oc_currents_residuals(filein,fileout) 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  			Ricardo Domingues, AOML/NOAA
%  	
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ret.code=0;
try
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[timestr,transp] = textread(filein,'%s %f');

G_MEAN = nanmean(transp(:));

for i = 1:length(transp)

	yyyy(i) = str2num(timestr{i}(:,1:4));
	mm(i) = str2num(timestr{i}(:,5:6));
	dd(i) = str2num(timestr{i}(:,7:8)); 
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  CHECK LAST SEASON AVAILABLE

time_ref = julian(yyyy,mm,dd,0);
time_1d = nanmin(time_ref):1:nanmax(time_ref);
time_7d = nanmin(time_ref):7:nanmax(time_ref);

Tnow = clock;
%  yyyy_use = nanmin(yyyy):1:Tnow(1);
yyyy_use = 1993:1:Tnow(1)+1;% Only look at years after 1993
time_yr = julian(yyyy_use,7,3,0);

transp_1d = interp1(time_ref,transp,time_1d);
transp_1d = rmean(transp_1d,7);

[res,annsig,ANN365,STD365] = get_residuals_RD(time_1d,transp_1d,0);

res_7d = interp1(time_1d,res,time_7d);


%---------------------------------- Calculating Yearly averages
%  res_ann = rmean(res_7d,53);
%  res_yr = interp1(time_7d,res_ann,time_yr);
%  res_yr = res_yr - nanmean(res_yr);

c=0;
for y=yyyy_use
    c=c+1;
    INDseas = find(time_7d>=julian(y-1,6,1,0) & time_7d<julian(y-1,11,31,0));
    res_yr(c) = nanmean(res_7d(INDseas));
end

%--------------------------------------------------------------

STDyr = nanstd(res_yr);

%===========================================================================================
%  Quantifying if HIGH or LOW value

%  %  ratio = res_yr./STDyr; %OLD METHOD BASED ON STD

%  -----------Current method based on percentiles (1/3 low, 1/3 medium, 1/3 high)



%  Mean Values
ratio = zeros(1,length(res_yr));

res_sorted = sort(res_yr);

%  SIZEARR = length(res_yr);
SIZEARR = nansum(~isnan(res_yr));


length(res_yr);
ID20 = round(SIZEARR*0.25);
ID40 = round(SIZEARR*0.5);
ID60 = round(SIZEARR*0.75);
ID80 = round(SIZEARR*0.75);

%between 20-40% 
LIM1 = res_sorted(ID20);
LIM2 = res_sorted(ID40);
LIM2=0;
K = find(res_yr>LIM1 & res_yr<LIM2);
ratio(K) = -2;

%between 60-80% 
LIM1 = res_sorted(ID40);
LIM2 = res_sorted(ID60);
LIM1=0;
K = find(res_yr>=LIM1 & res_yr<=LIM2)
ratio(K) = 2;


%below 25% 
LIM1 = res_sorted(ID20);
K = find(res_yr<=LIM1);
ratio(K) = -3;

%above 80% 
LIM1 = res_sorted(ID80);
K = find(res_yr>LIM1);
ratio(K) = 3;



%  %  ratio = 2*ones(1,SIZEARR);

time_GMT = time_jul2GMT(time_yr);

%  whos
%  plot(time_GMT,res_7d)
%  gregaxy(time_ref,1)
%  pause(10)

map2gmt(time_GMT,ratio,res_yr,11,0,fileout);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
catch

	[ err_msg ] = get_err_msg;

	ret.code = -1;
        ret.msg = err_msg;

end 
