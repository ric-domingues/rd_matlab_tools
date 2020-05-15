function [TA]=t_table(alpha, nu)
% % t_table: Return a statistic table of the studentt t-distribution for use in a ttest
% % 
% % Syntax='';
% % 
% % [TA]=t_table(alpha, nu);
% % 
% % ***********************************************************
% %   
% % Description
% %   
% % [TA]=t_table(alpha, nu);
% % returns a table of statitstics for the student-t 
% % distribution given an array of right sided probabilities alpha and  
% % an array of nu degrees of freedom.  The t-statistic is computed 
% % for all combinations of alpha and nu are
% % 
% % Right sided means:
% % Values of alpha less than 0.5 will yield positive statistics and 
% % Values of alpha greater than 0.5 will yield negative statistics.
% % 
% % The program can be run without any input arguments and a default array 
% % of values for alpha and nu will be used.  
% %   
% % ***********************************************************
% %   
% % Input Variables
% %
% % alpha is the level of significance, cumulative probability
% %
% % nu is the number of degrees of freedom.
% %
% % ***********************************************************
% % 
% % Output Variables
% % 
% % TA   % Table of student-t statistics  
% %      % reference Biostatistical Analysis 
% %      % by Jerold H. Zar 4th Edition 1999  
% % 
% % ***********************************************************
% % 
% 
% Example='';
% 
% alpha=[0.4 0.3 0.2 0.15 0.1 0.05 0.025 0.02 0.015 0.01 0.0075 0.005 ...
% 0.0025 0.0005];      % probability of type 1 error
% 
% nu=[1:30 40 60 120 170];  % number of degrees of freedom
% 
% [TA]=t_distrib_table(alpha, nu);
% 
%
% % ***********************************************************
% % 
% % Subprograms
% % 
% % t_icpbf is the inverse cumulative probability function for the
% %         t-ditribution.  
% % 
% % 
% % ***********************************************************
% % 
% % This program was written by Edward L. Zechmann 
% % 
% %     date  18 January 2008
% % 
% % modified  28 January 2008   updated comments
% % 
% % modified  10 March   2008   Fixed bugs in the interpolation methods.
% %                             Updated comments
% % 
% % modified 11 September 2008   Updated Comments
% % 
% % ***********************************************************
% % 
% % Feel free to modify this code.
% % 

if nargin < 1 || isempty(alpha) || ~isnumeric(alpha)
    alpha=[0.4 0.3 0.2 0.15 0.1 0.05 0.025 0.02 0.015 0.01 0.0075 0.005 0.0025 0.0005];
end

if nargin < 2 || isempty(nu)|| ~isnumeric(nu)
    nu=[1:30 40 60 120 170 Inf];
end

num_nu=length(nu);
num_alpha=length(alpha);

TA=zeros(num_nu, num_alpha);

for e1=1:num_nu;
    for e2=1:num_alpha;
        [t1]=t_icpbf(alpha(e2), nu(e1));
        TA(e1, e2)=-t1;
    end
end
