function [max_ccx, max_lag, corrc, lags,significance_90] = check_corr5_RD(nao1, nao2, charstr, xcharstr, lag, i_plot);
%  function [max_ccx, max_lag, corrc, lags,significance_90] = check_corr5_RD(nao1, nao2, charstr, xcharstr, lag, i_plot);
% check the lagged correlation between nao1 and nao2
% use lag = maximum number of lags to use
% charstr = character string to put on summary plot
%  (started with a default lag=20;)
% output max_ccx = maximum correlation
% lag that occurs at
%
% no plotting if i_plot = 0
%                       = 1 plot
confidence_95 = 1.95996;
confidence_90 = 1.645;

[ster,ccx]=xct(nao1,nao2,lag);
%[ster,ccx]=pltcor2(nao1,nao2,lag,1);
[m,n]=size(ccx);

[max_ccx, index]=max(ccx(:,2).^2);
[ccx(index,1),ccx(index,2)];
max_ccx = ccx(index,2);
max_lag = ccx(index,1);

corrc=ccx(:,2);
lags=ccx(:,1);


%  [dof,gdpt,tindsc,mu,varx,xcvm,ncvm] = dofmissb(nao1,min(30,lag),lag,min(30,lag));

if (i_plot == 1)
    figure
        wysiwyg;
        plot(ccx(:,1),ccx(:,2),'linewidth',2); 
        hold on;
% 90%
        plot([ccx(1,1) ccx(m,1)],[ confidence_90*ster(1)  confidence_90*ster(1)],'r--', 'linewidth',2);
        plot([ccx(1,1) ccx(m,1)],[-confidence_90*ster(1) -confidence_90*ster(1)],'r--', 'linewidth',2);
% 95%
        plot([ccx(1,1) ccx(m,1)],[ confidence_95*ster(1)  confidence_95*ster(1)],'y--', 'linewidth',2);
        plot([ccx(1,1) ccx(m,1)],[-confidence_95*ster(1) -confidence_95*ster(1)],'y--', 'linewidth',2);
% 98%
        plot([ccx(1,1) ccx(m,1)],[2.5*ster(1) 2.5*ster(1)],'g--', 'linewidth',2);
        plot([ccx(1,1) ccx(m,1)],[-2.5*ster(1) -2.5*ster(1)],'g--', 'linewidth',2);
% 99%
        plot([ccx(1,1) ccx(m,1)],[2.8*ster(1) 2.8*ster(1)],'c--', 'linewidth',2);
        plot([ccx(1,1) ccx(m,1)],[-2.8*ster(1) -2.8*ster(1)],'c--', 'linewidth',2);

        plot(ccx(index,1),ccx(index,2),'*', 'markersize', 10, 'linewidth', 2)
        axis([ccx(1,1) ccx(m,1) min(ccx(:,2))*1.35 max(ccx(:,2))*1.35 ])
        text(ccx(1,1)*(1+.1)+.1*ccx(m,1), ccx(index,2)*1.1, ['max = ' num2str(ccx(index,2)) ', lag = ' num2str(ccx(index,1)) ', dof = ' num2str(1/ster(1)^2) ', 90% significant at ' num2str(1.7*ster(1))], 'fontsize', 14)
  %text(ccx(1,1)*(1+.1)+.1*ccx(m,1), ccx(index,2)*1.25, ['Dennis_{dof} = ' num2str(dof) ', 90% sig at ' num2str(1.7/sqrt(dof)) num2str(2./sqrt(dof)) ', T scale = 'num2str(tindsc) ])
        title(charstr, 'fontsize', 14)
        xlabel(['Lag, ' xcharstr ' (input leads output for +lag)'], 'fontweight', 'bold', 'fontsize', 14)
        ylabel('Correlation coefficient', 'fontweight', 'bold', 'fontsize', 14)
        set(gca, 'fontsize', 14)
        grid on;
        hold off
end

significance_90 = 1.7*ster(1);

clear ans ccx dof gdpt index lag mu n ncvm ster tindsc varx xcvm 



