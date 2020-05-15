function [V,SIG,ERR,X,Y]=get_trend(time,tseries,alph,PL);

%  [V,SIG,ERR,X,Y]=get_trend(time,tseries,alph,PL);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  	This function calculates the linear trend of the time series
%  		with significance ALPHA
%  
%  		V = trend value (units/days), if V = nan, trend not significant
%  		T = linear trend
%  		SIG = 1 if trend statistically significant
%  
%  		default alph = 0.05
%  
%  		Ricardo Domingues, AOML/NOAA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
V=nan;SIG=nan;ERR=nan;X=nan;Y=nan;

if(~exist('alph'))
	alph=0.05;
end

if(~exist('RMODE'))
	RMODE=1;
end

if(~exist('PL'))
	PL=0;
end

[m,n]=size(time);
if(m==1)
	time=time';
end
[m,n]=size(tseries);
if(m==1)
	tseries=tseries';
end

time_ref=time;

K=isnan(tseries);
tseries(K)=[];
time(K)=[];

K=isnan(time);
tseries(K)=[];
time(K)=[];

if(length(time)>5)
	[B,BINT] = regress(tseries-nanmean(tseries),time-nanmean(time),alph);
	P=polyfit(time,tseries,1);
	X = [(nanmin(time_ref)-3*nanmean(time_ref)) (nanmax(time_ref)+3*nanmean(time_ref))]; 
	Y=polyval(P,X);
	V=B;
	ERR = (BINT(2)-BINT(1))./2;

	if(BINT(1)<0 & BINT(2)>0)
		SIG=0;
	else
		SIG=1;
	end

	X = [(nanmin(time_ref)) (nanmax(time_ref))]; 
	Y=polyval(P,X);
%  	
%  	X2 = [(nanmin(time_ref)-nanmean(time_ref)) (nanmax(time_ref)-nanmean(time_ref))];		
%  	Y = B.*X2;

	if PL		
		plot(X,Y,'m')
	end


else
	SIG=0;
	V=nan;
	X = [(nanmin(time_ref)-nanmean(time_ref)) (nanmax(time_ref)+nanmean(time_ref))]; 
	Y= [nan nan];
	
end


%  %  %  %  %  
%  %  %  %  %  
%  %  %  %  %  if(length(time)>5)
%  %  %  %  %  	s = regstats(tseries,time,'linear','all');
%  %  %  %  %  
%  %  %  %  %  	if(RMODE==1)
%  %  %  %  %  
%  %  %  %  %  		Tregress = s.tstat.t(2);
%  %  %  %  %  		DF = s.tstat.dfe;
%  %  %  %  %  		Slope = s.beta(2);
%  %  %  %  %  		Intercept = s.beta(1);
%  %  %  %  %  		
%  %  %  %  %  		Tref = t_table(alph./2,DF);
%  %  %  %  %  		
%  %  %  %  %  		if(Tregress>Tref)
%  %  %  %  %  			SIG=1;
%  %  %  %  %  		else
%  %  %  %  %  			SIG=0;
%  %  %  %  %  		end
%  %  %  %  %  		
%  %  %  %  %  		T = time_ref*Slope + Intercept; % time line for plot
%  %  %  %  %  		V = Slope; % (units/sampling frequency)
%  %  %  %  %  	else
%  %  %  %  %  		Poly = polyfit(time,tseries,1);
%  %  %  %  %  		tval = polyval(Poly,time_ref);
%  %  %  %  %  		V = [tval(end)-tval(1)]/[(time_ref(end)-time_ref(1))];
%  %  %  %  %  		[R,P]=corrcoef(time,tseries);
%  %  %  %  %  		T=tval;
%  %  %  %  %  		
%  %  %  %  %  		if(isempty(find(P<[1-alph])))
%  %  %  %  %  			V=nan;
%  %  %  %  %  		end
%  %  %  %  %  else
%  %  %  %  %  
%  %  %  %  %  	T = nan;
%  %  %  %  %  	V = nan;
%  %  %  %  %  	SIG = 0;
%  %  %  %  %  end
%  %  %  %  %  
