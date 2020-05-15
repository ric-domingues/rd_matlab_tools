	function PROFB=keep_good_prof(profb,vari,flag_good,ID)
%  	function PROFB=keep_good_prof(profb,vari,flag_good,ID)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% - this function returns good profiles based on the user options
% - eliminate profiles that are all NaN (only bother about variables used later)
% - keeps specific samples, e.g XBT, CTD, Argo
%
%       usage: PROFB=keep_good_prof(profb,var,flag_good,ID)
%
%	require: box_withdata.m
%		 flag_eval.m
%
%	profb ------------------------------------------> box profiles	
%	var = ------------------------------------------> Variables to eval (e.g stp)
%		p = press, s = salt, t = temperature
%	flag_good --------------------------------------> value of the good profiles (default = 1)
%	ID ---------------------------------------------> String of samples to keep (e.g PC)
%		C = CTD, P = ARGO, X = XBT, U ----
%	
%	 
%	adapted by R. Domingues - AOML/NOAA, August 01,2011
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			
flag_good=1;

if(exist('flag_good')==0)
	flag_good=1;
end

flag_good

if(~exist('ID') || isempty(ID))
	ID='CPXU';
end

if(~exist('vari'))
	vari='pst';
end
var=vari;

COM = ['ii=find(~isnan(max9(profb(l1(l),l2(l)).pres+profb(l1(l),l2(l)).temp)) & ( '];
for i=1:length(ID)
	
	if(i>1),COM=[COM,'|'];end

	IDD = ID(i);
	switch lower(IDD)
	
		case {'p'}
			COM=[COM,' profb(l1(l),l2(l)).typ == ''p'' | profb(l1(l),l2(l)).typ == ''P'' '];
		case {'c'} 
			COM=[COM,' profb(l1(l),l2(l)).typ == ''C'' | profb(l1(l),l2(l)).typ == ''c'' '];
		case {'x'}
			COM=[COM,' profb(l1(l),l2(l)).typ == ''X'' | profb(l1(l),l2(l)).typ == ''x'' '];
		case {'u'}
			COM=[COM,' profb(l1(l),l2(l)).typ == ''U'' | profb(l1(l),l2(l)).typ == ''u'' '];		
	end

end
COM=[COM,'));'];


%with_others, with_clim, with_visual ------------> refer to flag_eval.m

[ num, l1, l2 ] = box_withdata( profb, 'temp' ); %------------------------------NEED TO BE FIXED

	for l = 1:length( l1 )		
		
		% set bad data to NaN
		if(~isempty(find(lower(var)=='p')))
         		ii=find(profb(l1(l),l2(l)).pres_flag~=flag_good); profb(l1(l),l2(l)).pres(ii)=NaN;
		end
		if(~isempty(find(lower(var)=='t')))
	%           	ii=find(flag_eval(profb(l1(l),l2(l)).temp_flag,with_others,with_clim,with_visual)~=flag_good); profb(l1(l),l2(l)).temp(ii)=NaN;
			ii=find(profb(l1(l),l2(l)).temp_flag~=flag_good); profb(l1(l),l2(l)).temp(ii)=NaN;
		end
		if(~isempty(find(lower(var)=='s')))
	         	ii=find(profb(l1(l),l2(l)).sal_flag~=flag_good); profb(l1(l),l2(l)).sal(ii)=NaN;
		end

        	for m=1:length(profb(l1(l),l2(l)).time)%---------------------------m mark the number of profiles on the box and its dates
			% profile length must exceed 1, otherwise set pres to NaN
            		if length(find(~isnan(profb(l1(l),l2(l)).pres(:,m)+ profb(l1(l),l2(l)).temp(:,m))))<2
               			profb(l1(l),l2(l)).pres(:,m)=NaN;
            		end
         	end
		
		eval(COM)		

		profb(l1(l),l2(l)).id=profb(l1(l),l2(l)).id(ii);
		profb(l1(l),l2(l)).typ=profb(l1(l),l2(l)).typ(ii);
		profb(l1(l),l2(l)).time=profb(l1(l),l2(l)).time(ii);
         	profb(l1(l),l2(l)).longitude=profb(l1(l),l2(l)).longitude(ii);
         	profb(l1(l),l2(l)).latitude=profb(l1(l),l2(l)).latitude(ii);
         	profb(l1(l),l2(l)).pres=profb(l1(l),l2(l)).pres(:,ii);
         	profb(l1(l),l2(l)).temp=profb(l1(l),l2(l)).temp(:,ii);										
								
      	end % for l=1:length(l1)

PROFB = profb;