function plot_MODIS_sst(filein,LON_LIM,LAT_LIM,Lthrs);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	This function plots a map from a specific MODIS sst filein
%  
%  			Ricardo Doingues, AOML/NOAA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  ret.code=0;
%  
%  try
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
M=4320;
N=8640;

l3m_data = hdfread(filein, '/l3m_data', 'Index', {[1  1],[1  1],[M  N]});
l3m_qual = hdfread(filein, '/l3m_qual', 'Index', {[1  1],[1  1],[M  N]});
l3m_data=double(l3m_data);

lon=linspace(-180,180,N);
lat=linspace(-90,90,M);
slope=0.00071718;
intercept=-2;

sst = (slope*l3m_data) + intercept;
sst=flipud(sst);
l3m_qual=flipud(l3m_qual);

IND_lon = find(lon>=LON_LIM(1) & lon<=LON_LIM(2));
IND_lat = find(lat>=LAT_LIM(1) & lat<=LAT_LIM(2));

lon=lon(IND_lon);lat=lat(IND_lat);
[lon,lat]=meshgrid(lon,lat);

sst=sst(IND_lat,IND_lon);
mask=l3m_qual(IND_lat,IND_lon);
K=find(mask>1);
sst(K)=nan;
K=find(sst<Lthrs);
sst(K)=nan;
sst=inpaint_nans(sst,5);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plotting
%  imagesc(sst),colorbar
%  pcolor(lon,lat,sst), shading interp, caxis([20 30])
%  pause
m_proj('merc','lon',LON_LIM,'lat',LAT_LIM);
m_contourf(lon,lat,sst,20),shading flat;hold on

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  catch
%  
%  	[ err_msg ] = get_err_msg;
%  
%  	ret.code = -1;
%          ret.msg = err_msg;
%  
%  end 
