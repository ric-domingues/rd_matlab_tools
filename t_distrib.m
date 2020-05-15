function [h, T, t]=t_distrib(t, nu, make_plot)
% % t_distrib: Calculates the studentt t-distribution and makes a plot
% % Syntax='';
% % 
% % [h, T, t]=t_distrib(t, nu, make_plot);
% % 
% % ***********************************************************
% % 
% % Description
% % 
% % [h]=t_distrib(t, nu, make_plot);
% % returns an array of the student-t probability distribution function 
% % for the vector t statistic, and scalar nu degrees of freedom. 
% % 
% % [h, T]=t_distrib(t, nu, make_plot);
% % Returns the cumulative probabilty function T.
% % Makes a plot of h the probability density function and T 
% % cumulative probabiliity function.  
% % 
% % 
% % The values of t must be numeric and values of Inf and -Inf are allowed. 
% % The values of nu must be numeric and Inf is allowed.
% %   
% % The default value for nu is Inf and is approximated by the 
% % standard normal distribution.
% % 
% % The input and output variables are described in detail below.
% % 
% % ***********************************************************
% % 
% % Input Variables
% % 
% % t is the measured statistic value -Inf < t < Inf.
% %
% % nu is the number of degree of freedom 1 <= nu < Inf.
% % 
% % make_plot=1; makes a plot of the probability density function and
% %              cumulative probabiliity function.  
% %              Otherwise 
% % 
% % ***********************************************************
% % 
% % Output Variables
% % 
% % h   % student-t probability distribution function 
% % 
% % T   % cumulative probability function 
% % 
% % t   % Measured Value of the t-statistic.
% % 
% % 
% % ***********************************************************
% 
% Example='';
%
% [h, T, t]=t_distrib;
%
% nu=200;                   % number of degrees of freedom
% [h, T, t]=t_distrib([], nu, 1);
%
% nu=1;                     % number of degrees of freedom
% [h2, T2, t2]=t_distrib([], nu, 1);
%
% 
% % 
% % ***********************************************************
% % 
% % 
% % List of Dependent Subprograms for 
% % t_distrib
% % 
% % 
% % Program Name   Author   FEX ID#
% % 1) genHyper		Ben Barrowes		6218	
% % 2) geospace		
% % 3) sd_round		
% % 4) t_alpha		
% % 5) t_function	
% % 
% % ***********************************************************
% % 
% % 
% % This program was written by Edward L. Zechmann 
% % 
% %     date  18 January 2008
% % 
% % modified  20 January 2008   updated comments
% %                             added code to round nu
% % 
% % modified  21 January 2008   updated comments
% % 
% % modified  23 January 2008   updated comments
% %                             fixed bug added geospace to the zip file
% % 
% % modified   9 March   2008   
% % 
% % ***********************************************************
% % 
% % Feel free to modify this code.
% % 

special_scale=0;
if nargin < 1 || isempty(t) || ~isnumeric(t)
    % use a logrithmic spacing of data points from
    % -10000 to 0 then from 0 to 1000
    t=geospace(10^(-3),10^3,1000, 1);

    % Make sure all values are unique and in ascending order
    t=[-fliplr(t) 0 t  ];
    t=unique(t);
    special_scale=1;
    
end

% Default is the normal distribution
if nargin < 2 || isempty(nu) || ~isnumeric(nu)
    nu=Inf;  
end

nu=round(nu);

if nu < 1
    nu=1;
end

if nargin < 3
    make_plot=1;
end

% if nu is 321 or more then the gammma function diverges and the 
% normal distribution becomes an effective approximation

h=t_function(t, nu);

[T]=t_alpha(t, nu);

if make_plot == 1
    
    figure(1);
    subplot(2, 1, 1 );
    plot(t, h);
    xlim([min(t) max(t)]);
    title({'The Probabilty Density Function', [' T-Distribution \nu = ', num2str(nu)]}, 'fontsize', 18);
    ylabel('Probability Density', 'fontsize', 14);
    ylim([min(h), max(h)]);
    xlim([min(t) max(t)]);
    set(gca, 'fontsize', 16);
    
    
    subplot(2, 1, 2 );
    plot(t, T);
    xlim([min(t) max(t)]);
    title({'The Cumulative Probabilty Function', [' T-Distribution \nu = ', num2str(nu)]}, 'fontsize', 18);
    ylabel('Cumulative Probability ', 'fontsize', 14);
    ylim([-0.1, 1.1]);
    xlabel('Measured Value', 'fontsize', 18);
    xlim([min(t) max(t)]);
    set(gca, 'fontsize', 16);
    
    if special_scale == 1
        
        figure(2);
        subplot(2, 1, 1 );
        plot(1:length(h),h);
        xlim([1 length(h)]);
        title({'The Probabilty Density Function', [' T-Distribution \nu = ', num2str(nu)]}, 'fontsize', 18);
        ylabel('Probability Density', 'fontsize', 14);
        ylim([min(h), max(h)]);

        n1=length(t);
        n2=1001;
        n3=500;
        n4=1502;
        xtick=[1 n3 n2 n4 n1];
        [buf, XTickLabel]=sd_round(t(xtick), 1);

        set(gca, 'xtick', xtick, 'XTickLabel', XTickLabel);
        xlim([1 length(h)]);
        set(gca, 'fontsize', 16);


        subplot(2, 1, 2 );
        plot(1:length(h),T);
        xlim([1 length(h)]);
        title({'The Cumulative Probabilty Function', [' T-Distribution \nu = ', num2str(nu)]}, 'fontsize', 18);
        ylabel('Cumulative Probability ', 'fontsize', 14);

        ylim([-0.1, 1.1]);
        n1=length(t);
        n2=1001;
        n3=500;
        n4=1502;
        xtick=[1 n3 n2 n4 n1];
        [buf, XTickLabel]=sd_round(t(xtick), 1);

        set(gca, 'xtick', xtick, 'XTickLabel', XTickLabel);
        xlim([1 length(h)]);
        xlabel('Log Scale of Measured Value', 'fontsize', 18);
        set(gca, 'fontsize', 16);
    end
    
end


