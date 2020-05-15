function [n, ni, cna, na, count, error]=t_mean_num_obs(alpha, beta, delta, pair_or_unpair, one_or_two_tails, threshold)
% % t_mean_num_obs: Calculates the number of observations required to infer ststistical significance of the ttest of means
% % 
% % Syntax='';
% % 
% % [n, ni, cna, na, count, error]=t_mean_num_obs(alpha, beta, delta, ...
% % pair_or_unpair, one_or_two_tails, threshold);
% % 
% % ***********************************************************
% %
% % Description
% % 
% % This program calculates the number of observations necessary
% % to control the probabilities of type 1 and type 2 errors.
% %
% % Applicable statistical test situations include:
% %      paired or unpaired t-tests
% %      one or two tails
% %
% % The input and output variables are detailed below.  
% %
% % See the Examples for the syntax and definitions of the input arguments.
% %
% % ***********************************************************
% %
% % Input Variables
% % 
% % alpha is the level of significance and probability of type 1 error.
% %           Default value is 0.05.
% %
% % beta is the probability of type 2 error.
% %           Default value is 0.1.
% %
% % delta for the one sample test of the mean is the ratio of the 
% %           difference in the mean from 0 to the standard deviation of
% %           the samples.
% %       
% % delta for paired tests is the ratio of the difference in the mean 
% %           from 0 to the standard deviation of the difference of 
% %           the samples.
% %           
% % delta for unpaired tested is the ratio of the difference in the means
% %           to the standard deviation of the sample means.  
% % 
% % The default value of delta is 1.  
% % 
% % pair_or_unpair=1; Is paired.  Otherwise is unpaired.  
% % 
% % one_or_two_tails=1; The test has one tail.  Otherwise two-tails.
% %                     default is two-tails.
% % 
% % threshold=0;  Amount of rounding down to allow when calculating the
% %               number of obervations required.  
% %               Default is 0.  Maximum is 0.499.  
% % 
% % ***********************************************************
% %
% % Output Variables
% %
% %         % reference Biostatistical Analysis
% %         % by Jerold H. Zar 4th Edition 1999
% %
% % n       % Is the number of observations needed to control the type 1
% %         % and type 2 errors given the statistical conditions
% %         % alpha, beta, and delta.  
% %         % n is also called the 
% %         %    number of required replicates
% %         %    number of required repititions
% %         % 
% %         % n is empty is there is an input error or lack of convergence
% %         %   
% %         % n is set to Infinity if ni > 150 
% %
% % ni      % Interpolated equal point between the input number of
% %         % observations and the output number of observations
% %         %
% %         % ni is the optimum solution.
% %         % 
% %         % ni is empty if there is bad input
% %         % ni is set to Infinity if ni > 150 
% % 
% % cna     % row vector of the ceiling of the input number of observations
% %
% % na      % row vector of the calculated number of observations given
% %         % the input cna
% %
% % count   % number of iterations to have a data points on either side of
% %         % the equal point, ni.  
% %         % This satisfies the condition
% %         % cna(n2) > na(n2) and cna(n2+1) < na(n2+1) 
% %         %   or the condition
% %         % cna(n2) > na(n2) and cna(n2-1) < na(n2-1) 
% % 
% %         % count is empty if there is an error 
% % 
% % error   % 0 is no errors are detected
% %         % 1 if errors are detected
% % 
% % ***********************************************************
% %
%
% Example='';
%
% alpha=0.05;   % level of significance.  Probability of type 1 error
%               % Falsely reject the null hypothesis
%               % when null hypothesis is true
%               % default value is 0.05
%
% beta=0.1;     % Probability of type 2 error
%               % Falsely accept the null hypothesis
%               % when null hypothesis is actually false
%               % default value is 0.1
%
% delta=1;      % For the one sample test of the mean
%               %
%               % delta is the ratio of the difference in the mean from 0
%               %       to the standard deviation of the samples
%
%               % For paired test of the means
%               %
%               % delta is the ratio of the difference in the means
%               %       to the standard deviation of difference of the
%               %       sample means.
%
%               % For the two sample upaired test of the difference
%               % of two means
%               %
%               % delta is the ratio of the difference in the means
%               %       to the standard deviation of the means
%               
%               % typically delta has the range 
%               %   0 < delta < 6 
%               % default value is 1
%
% pair_or_unpair=2; % 2 is the two sample unpaired t-test of the
%                   %   difference of the means
%                   %
%                   % 1 if test of one sample test of a single mean
%                   %   different than zero.
%                   %
%                   % 1 one sample paired t-test of the difference of means
%                   %   The null hypothesis that the means are equal.
%                   %
%                   % otherwise two sample unpaired t-test
%                   %           of the difference of two means
%
% one_or_two_tails=2;	% 1 is a one sided t-test
%                       %   alpha is a one sided level of significance
%
%                       % otherwise two sided t-test
%                       %   alpha is a two sided level of significance
%
%                       % default is two sided
%
% threshold=0;  % Depending on the application a threshold
%               % may be applied to determine whether to round up or to
%               % round down.
%               % The threshold can be as high as 0.499
%               % Threshold allows rounding the number of required
%               % observations down to nearest integer by a maximum amount
%               % of threshold.
%               % default threshold is 0.
%
% [n, ni, cna, na, count, error]=t_mean_num_obs(alpha, beta, delta, ...
% pair_or_unpair, one_or_two_tails, threshold);
%
% Example='';
%
% alpha=0.0005; % Level of significance.  Probability of type 1 error
%
% beta=0.01;    % Probability of type 2 error
%
% delta=1.5;    % ratio of the difference in the means to the standard
%               % deviation of the means
%
% pair_or_unpair=1;       % one sample t-test of the means
%
% one_or_two_tails=2;      % double sided t-test
%
% threshold=0.2;    % Round the number of observations down by a maximum of
%                   % threshold.
%
% [n, ni, cna, na, count, error]=t_mean_num_obs(alpha, beta, ...
% delta, pair_or_unpair, one_or_two_tails, threshold);
%
% % ***********************************************************
% % 
% % Subprograms
% % 
% % t_icpbf is the inverse cumulative probability function.  
% % 
% % ***********************************************************
% %
% % This program was written by Edward L. Zechmann
% %
% %     date 18 January   2008
% %
% % modified 21 January   2008   updated the subprograms
% %
% % modified 23 January   2008   Added maxn and roundn as outputs
% %
% % modified 24 January   2008   Added threshold
% %                              updated comments
% %
% % modified 28 January   2008   Changed rounding method to calculate ni
% %                              Fixed a bug in calculating n
% %                              Bug affected only January 24 version
% %                              Removed maxn and roundn as outputs
% %
% %                              Added an error output and warnings for bad
% %                              input
% % 
% % modified 30 January   2008   Fixed bug which occurs when the  
% %                              number of required observations is
% %                              less than 3.  If calculations succeed 
% %                              then the output is the lower estimate of 
% %                              the required number of observations. 
% %                                 
% %                              If the calculations fail, then the output 
% %                              is an empty array, a warning is printed at
% %                              the command line, and error=1.
% % 
% % modified 10 March     2008   Updated the comments.   
% % 
% % modified 11 September 2008   Updated Comments
% % 
% % ***********************************************************
% %
% % Feel free to modify this code.
% %
% %

% set the error flag to null
flag=0;
error=0;

if nargin < 1  
    alpha=0.05; % probability of a type 1 error
end             % falsely reject the null hypothesis when it is true

if isempty(alpha) || logical(alpha < 0) || logical(alpha > 1) ||  ~isnumeric(alpha)
    flag=1;
    warning('Input alpha is empty or out of range.  Correct range is 0 < alpha < 1.  Output empty vectors');
end

if  nargin < 2 
    beta=0.10;  % probability of a type 2 error
end             % falsely accept the null hypothesis when it is false

if isempty(beta) || logical(beta < 0) || logical(beta > 1) ||  ~isnumeric(beta)
    flag=1;
    warning('Input beta is empty or out of range.  Correct range is 0 < beta < 1.  Output empty vectors');
end

if nargin < 3
    delta=1;    % assume ratio of diffrence between means to the
end             % standard deviaiotn of the means is unity

if isempty(delta) || logical(delta < 0) ||  ~isnumeric(delta)
    flag=1;
    warning('Input delta is empty or out of range.  Correct range is 0 < delta.  Output empty vectors');
end

if nargin < 4
    pair_or_unpair=2;     % assume two-sample t-test of the differnece of two means
end

if ~isequal(pair_or_unpair, 1)
    pair_or_unpair=2;       % if input is not 1 then assume a 
end                         % two-sample t-test of the means

if nargin < 5
    one_or_two_tails=2;     % assume two-sided t-test of mean
end

if ~isequal(one_or_two_tails, 1)
    one_or_two_tails=2;     % if input is not 1 then assume a 
end                         % two-sided t-test of mean

if nargin < 6
    threshold=0;    % a threshold of zero is a conservative approach
end

% Make sure the threshold for rounding ni is reasonable
% The acceptable range for ni is
% ni < 0.499 
% ni > 0     
if threshold > 0.499
    threshold=0.499;
elseif threshold < 0
    threshold=0;
end

if isequal(flag, 1)
    n=[];
    ni=[]; 
    cna=[];
    na=[];
    count=[];
    error=1;
    
else

    n1=1;
    n2=2;
    n3=3;
    n=7;
    count=0;
    flag1=1;
    cna=[];
    na=[];

    cna=[cna ceil(n)];

    % Interpolate the cumulative Percentage of the t-distribution
    [ta]=t_icpbf(alpha/one_or_two_tails, ceil(n-1));
    [tb]=t_icpbf(beta, ceil(n-1));

    n=pair_or_unpair/(delta^2)*(ta+tb)^2;

    na=[na n];
    % limit loop to 100 iterations;
    max_count=20;

    dra=2:200;

    while isequal(flag1,1) && logical(count < max_count)

        % only run cases that have not been run before

        count=count+1;

        if ismember(ceil(n), cna);
            dra2=setdiff(dra, cna);
            [buf ix]=min(abs(dra2-ceil(n)));
            n=dra2(ix);
        end

        if n < 2
            n=2;
        end

        cna=[cna ceil(n)];

        % Interpolate the cumulative Percentage of the t-distribution
        [ta]=t_icpbf(alpha/one_or_two_tails, ceil(n-1));
        [tb]=t_icpbf(beta, ceil(n-1));

        % calculate n
        n=pair_or_unpair/(delta^2)*(ta+tb)^2;

        % sort the calculated data
        na=[na n];
        [na ixna]=sort(na);
        cna=cna(ixna);

        n1=length(na);
        n2=find(cna >= na, 1, 'last' );
        n3=find(cna <= na, 1 );

        if n1 > 2
            if abs(cna(n2)-cna(n3)) <= 1
                n=cna(n2);
                flag1=0;
            elseif  logical(length(find( cna==2)) > 2)
                n=2;
                flag1=0;
            elseif logical(length(find( cna > 150)) > 4)
                flag1=0;
                n=cna(n2);
            end
        end

    end
    
    if isequal(flag1,1) && logical(count >= max_count)
        warning('Calculation did not converge in 20 iterations.  Output empty vectors');
        error=1;
    else
        
        % final estimate of n
        
        if isempty(n3) || isempty(n2)% case that very few observations are necessary
            if isempty(n3) && ~isempty(n2)
                n=cna(n2);
                ni=n;
            else
                ni=[];
                n=[];
                error=1;
                warning('Cannot calculate number of observations required.  Returning empty constant');
            end
        else

            y=[cna(n2), cna(n3)];
            x=[na(n2), na(n3)];


            if min(y) > 150
                ni=Inf;
                n=Inf;
                error=1;
                warning('Infinite number of observations required.  Returning Inf');
            else

                % The cna array is approximately equal to the na curve at data point ni.
                % compute ni by linear intepolation
                m=(y(2)-y(1))/(x(2)-x(1)); % slope
                ni=(-m*x(2)+y(2))/(1-m);

                roundn=round(ni);
                maxn=ceil(ni);

                % Apply a threshold criterion to determine if fewer observations is
                % acceptable
                if ni - roundn > threshold
                    % output the maxn if the value exceeds the threshold
                    n=maxn;
                else
                    % calculate the output and subtract the threshold
                    % the number of observations may be reduced by one
                    n=ceil(ni-threshold);
                end
            end

        end
        
    end
    
end

