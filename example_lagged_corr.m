function example_lagged_corr

	close all

	WID=1:2:60;
	MAX_LAG = 60;

	t1 = zeros(1,100);
	t2 = zeros(1,100);
	t2(10:15)=nan;

	aux = linspace(-pi/2,pi/2,30);
	taux = cos(aux);
	
	t1(11:40)=taux;
	t2(31:60)=-taux;
		

	PL=auto_plot(1,3,1,.4,.7,1,.7,9,6);

	[corrc, lags, max_corr,lag, T2_lagged] = lagged_corr_RD(t2,t1,MAX_LAG);
	plot(lags,corrc,'k')
	xlabel('\bf Lags [sampling units]')
	title('\bf Correlation coefficients with no-filtering')
	set(gca,'handlevisibility','off')
	max_corr

%  	figure
	[COR,WID,LAG,SIG] = coherence2D_RD(t2,t1,WID,MAX_LAG,0.05,1);
	set(gca,'handlevisibility','off')

	h(1)=plot(t1);hold on
	h(2)=plot(t2,'r');
	h(3)=plot(T2_lagged,'g');
	ylim([-1.2 1.2])	
	legend(h,'Tseries 1','Tseries 2','Tseries 1 (lag applied)');
	xlabel('\bf time units')
	title('\bf Tseries1 forces Tseries2','fontsize',14)

	set(gca,'handlevisibility','off')

