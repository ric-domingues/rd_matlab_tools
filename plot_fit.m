function [R,Psig,P]=plot_fit(X,Y,COLOR,TEXT,PL);

%  function [R,Psig,P]=plot_fit(X,Y,COLOR,TEXT);

if(~exist('COLOR'))
	COLOR='k';
end


if(~exist('PL'))
	PL=1;
end

K=isnan(X);
X(K)=[];
Y(K)=[];
K=isnan(Y);
X(K)=[];
Y(K)=[];

[MM,NN] = size(Y);
Y = reshape(Y,MM*NN,1);
X = reshape(X,MM*NN,1);

P=polyfit(X,Y,1);
RNGX = abs(max(X) - min(X));
RNGY = abs(max(Y) - min(Y));

[R,Psig]=corrcoef(X,Y);

K=find(Psig<0.05);

Xval = linspace(min(X)-RNGX*0.3,max(X)+RNGX*0.3,20);
Yval = polyval(P,Xval);

if(PL)

    plot(X,Y,'ko','markersize',5,'markerfacecolor',COLOR),hold on
    plot(Xval,Yval,'color',[.4 .4 .4],'linewidth',1.5)

    SLOPE = (Yval(end)-Yval(1))./(Xval(end)-Xval(1));

%  %      disp(['Slope = ',num2str(SLOPE)])

    xlim([min(X)-RNGX*0.3,max(X)+RNGX*0.3])
    ylim([min(Y)-RNGY*0.2,max(Y)+RNGY*0.2])

    if(isempty(K))
	    text(min(X)-RNGX*0.2,min(Y)-RNGY*0.12,['\bf r=',sprintf('%03.2f',R(1,2))],'fontsize',12,'color','r');
    else
	    text(min(X)-RNGX*0.2,min(Y)-RNGY*0.12,['\bf r=',sprintf('%03.2f',R(1,2))],'fontsize',12);

    end

    if(exist('TEXT'))
	    text(min(X)-RNGX*0.2,max(Y)+RNGY*0.07,TEXT,'fontsize',12);
    else
	    text(min(X)-RNGX*0.2,max(Y)+RNGY*0.12,sprintf('Slope = %03g',P(1)),'fontweight','bold')
	    text(min(X)-RNGX*0.2,max(Y)+RNGY*0.02,sprintf('Bias = %03g',P(2)),'fontweight','bold')
    end
    grid on

end
