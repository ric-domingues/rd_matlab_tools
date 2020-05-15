function h=plot_filled(X,Y,Y0,TYPE,COLOR,FILLCOLOR,vertHor);
%function plot_filled(X,Y,Y0,TYPE,COLOR,FILLCOLOR,vertHor);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%	This function makes the plot(X,Y) filling the areas bellow and/or
%		above Y0 with COLOR
%
%		Created by, Ricardo M. Domingues
%		- Ricardo.Domingues@noaa.gov
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if(~exist('TYPE'))
    TYPE='lg';
end

if(~exist('COLOR'))
    COLOR='kk';
end

if(~exist('FILLCOLOR'))
    FILLCOLOR={'k' 'r'};
end

if(~exist('Y0'))
    Y0=nanmean(Y);
end

if(~exist('vertHor'))
    vertHor='h';
end

X0=Y0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plot_filled horizontal

if(vertHor=='h')


if(length(COLOR)<=2)
	h=plot(X,Y,COLOR(1),'linewidth',0.2),hold on	
else
	h=plot(X,Y,'color',COLOR,'linewidth',0.2),hold on
end

Y_ref = Y;
X_ref = X;

int = linspace(0,1,length(X));
int_i = linspace(0,1,length(X)*100);

X = interp1(int,X,int_i);
Y = interp1(int,Y,int_i);

%================ filling bellow Y0 =======================================

I = find(TYPE=='l');

if(~isempty(I))	
	IND1 = find(Y<Y0);
	
	Y1_aux = Y0.*ones(size(Y));
	Y1_aux(IND1) = Y(IND1);
	
	X1_fill = [X,fliplr(X)];
	Y1_fill = [Y1_aux,Y0.*ones(size(Y))];
  	
	if(length(FILLCOLOR)<=2)
		fill(X1_fill,Y1_fill,FILLCOLOR{I},'edgecolor','none');
	else
		fill(X1_fill,Y1_fill,FILLCOLOR,'edgecolor','none');
	end
	
end

%================ filling above Y0 =======================================
I = find(TYPE=='g');

if(~isempty(I))	
	IND1 = find(Y>Y0);
	
	Y1_aux = Y0.*ones(size(Y));
	Y1_aux(IND1) = Y(IND1);
	
	X1_fill = [X,fliplr(X)];
	Y1_fill = [Y1_aux,Y0.*ones(size(Y))];
	
	if(length(FILLCOLOR)<=2)
		fill(X1_fill,Y1_fill,FILLCOLOR{I},'edgecolor','none');
	else
		fill(X1_fill,Y1_fill,FILLCOLOR,'edgecolor','none');
	end
	

end

%================ filling above Y0 =======================================
X=X_ref;Y=Y_ref;

if(length(COLOR)<=2)
	plot(X,Y,COLOR(1),'linewidth',0.2),hold on
	plot([X(1) X(end)],[Y0 Y0],COLOR(2),'linewidth',0.2);
	xlim([nanmin(X) nanmax(X)])
else
	plot(X,Y,'color',COLOR,'linewidth',0.2),hold on
	plot([X(1) X(end)],[Y0 Y0],'color',COLOR,'linewidth',0.2);
	xlim([nanmin(X) nanmax(X)])
end

end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plot_filled vertical
if(vertHor=='v')


if(length(COLOR)<=2)
	plot(X,Y,COLOR(1),'linewidth',0.2),hold on	
else
	plot(X,Y,'color',COLOR,'linewidth',0.2),hold on
end

Y_ref = Y;
X_ref = X;

int = linspace(0,1,length(X));
int_i = linspace(0,1,length(X)*100);

X = interp1(int,X,int_i);
Y = interp1(int,Y,int_i);

%================ filling bellow Y0 =======================================

I = find(TYPE=='l');

if(~isempty(I))	
	IND1 = find(X<X0);
	
	X1_aux = X0.*ones(size(X));
	X1_aux(IND1) = X(IND1);
	
	Y1_fill = [Y,fliplr(Y)];
	X1_fill = [X1_aux,X0.*ones(size(X))];
    
	if(length(FILLCOLOR)<=2)
		fill(X1_fill,Y1_fill,FILLCOLOR{I},'edgecolor','none');
	else
		fill(X1_fill,Y1_fill,FILLCOLOR,'edgecolor','none');
	end
	
end

%================ filling above Y0 =======================================
I = find(TYPE=='g');

if(~isempty(I))	
	IND1 = find(X>X0);
	
	X1_aux = X0.*ones(size(X));
	X1_aux(IND1) = X(IND1);
	
	Y1_fill = [Y,fliplr(Y)];
	X1_fill = [X1_aux,X0.*ones(size(X))];
	
	if(length(FILLCOLOR)<=2)
		fill(X1_fill,Y1_fill,FILLCOLOR{I},'edgecolor','none');
	else
		fill(X1_fill,Y1_fill,FILLCOLOR,'edgecolor','none');
	end
	

end

%================ filling above Y0 =======================================
X=X_ref;Y=Y_ref;

if(length(COLOR)<=2)
	plot(X,Y,COLOR(1),'linewidth',0.2),hold on
	plot([X(1) X(end)],[Y0 Y0],COLOR(2),'linewidth',0.2);
	xlim([nanmin(X) nanmax(X)])
else
	plot(X,Y,'color',COLOR,'linewidth',0.2),hold on
	plot([X(1) X(end)],[Y0 Y0],'color',COLOR,'linewidth',0.2);
	xlim([nanmin(X) nanmax(X)])
end

end




