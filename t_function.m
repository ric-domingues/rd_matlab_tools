function [h]=t_function(t, nu)
% % t_function: t-distribution, probabiilty function, cumulative probabiilty function 
% % 
% % Syntax='';
% % 
% % [h]=t_function(t, nu);
% % 
% % ***********************************************************
% % 
% % Description
% % 
% % This program calculates the student-t distribution for nu degrees of 
% % freedom.  The default is nu=Inf of freedom which is the standard normal
% % distribution. 
% %  
% % ***********************************************************
% % 
% % Input Variables
% % 
% % t is the measured statistic value -Inf < t < Inf. t can be an array
% %
% % nu is the number of degree of freedom 1 <= nu < Inf.
% %     For ranges of 1 < nu <= 150 the distribution is calculated from the
% %     analytical expression.  For nu > 150 the normal distribution 
% %     approximation is used.  nu is a constant.  
% % 
% % ***********************************************************
% % 
% % Output Variables
% % 
% % h   % student-t probability distribution function 
% % 
% % ***********************************************************
% %
%
% Example='';
% 
% nu=200;                   % number of degrees of freedom
% t=geospace(-1000, 0, 2000, 0);
% t=[t -fliplr(t) ];
% [h]=t_function(t, nu);
% plot(t, h, 'g');
%
% hold on;
% nu=1;                   % number of degrees of freedom
% [h2]=t_function(t, nu);
% plot(t, h2, 'r');
% title('The normal and T-Distribution', 'fontsize', 24);
% ylabel('Probability', 'fontsize', 18);
% xlabel('Measured Value', 'fontsize', 18);
% ylim([-0.1, 0.5]);
% xlim([-10 10]);
% legend('Normal', 't_\nu_=_1');
% set(gca, 'fontsize', 16);
% 
%
% % ***********************************************************
% % 
% % This program was written by Edward L. Zechmann 
% % 
% %     date 20 January   2008
% % 
% % modified 11 September 2008  Updated Comments
% % 
% % ***********************************************************
% % 
% % Feel free to modify this code.
% % 

if nargin < 1 || isempty(t) || ~isnumeric(t)
    t=1;
end

if nargin < 2 || isempty(nu) || logical(nu < 1)  || ~isnumeric(nu)
    nu=Inf;
end

nu=round(nu(1));

un=ones(size(t));

if nu < 150
    
    % t-distribution 
    % nu degrees of freedom
    h=gamma((1+nu)/2)./(gamma(nu/2).*sqrt(pi*nu)).*(un+t.^2./nu).^(-(nu+1)/2);

else
    % standard normal curve 
    % the standard deviation is set to unity
    h=1./sqrt(2*pi).*exp(-0.5*t.^2);

end

