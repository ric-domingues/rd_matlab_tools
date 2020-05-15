function [t_out, T_out, error1_out, error2_out, count_out]=t_icpbf(alpha, nu)
% % inverse cumulative probability function, t-distribution
% %
% % Syntax='';
% %
% % [t_out, T_out, error1_out, error2_out, count_out]=t_icpbf(alpha, nu);
% %
% % ***********************************************************
% %
% % Description
% %
% % This program calculates the t-statistic given a level of
% % significance alpha.  alpha can be a vector.  nu must be a constant.
% %
% % In more technical language, this program is the inverse cumulative 
% % probability density function for the t-distribution.  
% %
% % The accuracy is generally 6 significant digits or more.
% % tol=10^(-8) is hard programmed.
% %
% % This program is an inverse cumulative probability function
% % for the t-distribution for a level of significance alpha and
% % nu degrees of freedom.
% %
% % For alpha less than 0.5, the statistic is negative.
% % For alpha greater than 0.5, the statistic is positive.
% % 
% % alpha=0.95 is the default level of significance or in other words
% % cumulative probability.
% %
% % The default value of nu is Inf (infinity) is is approximated by the 
% % normal distribution).
% % 
% %
% % ***********************************************************
% %
% % Input Variables
% %
% % alpha is the level of significance, cumulative probability
% %       alpha is a constant.
% % 
% % nu is the number of degrees of freedom.
% %        nu is a constant.
% % 
% % ***********************************************************
% %
% % Output Variables
% %
% % t_out       %  estimated statistic value of the student-t distribution
% %
% % T_out       % estimated cumulative probability function value
% %
% % error1_out  % error estimate of the significance level
% %
% % error2_out  % error estimate of the statistic value
% %
% % count_out   % number of iterations to reach tolerance or fail
% %
% % ***********************************************************
% %
%
% Example='';
% alpha=0.0005;         % level of significance
% nu=1;                 % number of degrees of freedom
%
% [t0005]=t_icpbf(alpha, nu);
%
% t0005exact=-636.6192487;
% Perror0005=100*(1 - t0005/t0005exact);
%
% alpha=0.95;           % level of significance
% nu=Inf;               % number of degrees of freedom (standard normal)
% [t95]=t_icpbf(alpha, nu);
%
% t95exact=1.64485362695;
% Perror95=100*(1 - t95/t95exact);
%
% %
% %
% % ***********************************************************
% %
% %
% % This program was written by Edward L. Zechmann
% %
% %     date  20 January 2008
% %
% %  modified 21 January 2008   updated comments
% %                             added atan and reciprocal
% %                             interpolation methods
% %                             added the offset to the interpolation
% %
% %  modified  9 March   2008   Modifed code to adjust the inerpolated
% %                             value.  Updated comments to reflect changes
% %                             in t_alpha.  Vectorized the program to
% %                             accept alpha as a vector.  
% %
% % ***********************************************************
% %
% %
% % Feel free to modify this code.
% %


% The 95 percent confidence interval is the default
if nargin < 1 || isempty(alpha) || ~isnumeric(alpha)
    alpha=0.95;
end

% alpha can be a vector
n2=length(alpha);

t_out=zeros(size(alpha));
T_out=zeros(size(alpha));
error1_out=zeros(size(alpha));
error2_out=zeros(size(alpha));
count_out=zeros(size(alpha));

% check special cases of alpha

set_t=1:n2;

ix=find( alpha <= 0 );
alpha(ix)=0;
t_out(ix)=-Inf;
T_out(ix)=0;
set_t=setdiff(set_t, ix);


ix=find( alpha >= 1 );
alpha(ix)=1;
t_out(ix)=Inf;
T_out(ix)=1;
set_t=setdiff(set_t, ix);

ix=find( alpha == 0.5 );
alpha(ix)=0.5;
t_out(ix)=0;
T_out(ix)=0.5;
set_t=setdiff(set_t, ix);


% The default is the normal distibution
if nargin < 2 || isempty(nu) || ~isnumeric(nu)
    nu=inf;
end

% nu must be a constant integer and be >= 1
nu=round(nu(1));

if nu < 1
    nu=1;
end

% set the required precision for convergence.
tol=10^(-8);


% make a small table so that the initial guess is generally within a factor of 10
if nu < 2
    t=-fliplr(-1+logspace(0, 9, 10));
elseif logical(nu >= 2) && logical(nu <= 5)
    t=-fliplr(-1+logspace(0, 3, 10));
elseif logical(nu > 5) && logical(nu <= 20)
    t=-fliplr(-1+logspace(0, 2, 10));
else
    t=-fliplr(-1+logspace(0, 1, 10));
end

n1=length(t);
T=zeros(size(t));

for e1=1:n1;
    T(e1)=t_alpha(t(e1), nu);
end


t=[t -fliplr(t)];
T=[T fliplr(1-T)];

% find the two closest values
[buf ixt]=unique(t);
[buf ixT]=unique(T);

ixtT=intersect(ixT, ixt);

t=t(ixtT);
T=T(ixtT);

n1=length(t);

n3=length(set_t);
max_count=100;

for e1=1:n3;

    % Rebuild the arrays for each value of alpha
    t2=1:n1;
    T2=t2;
    t2(1:n1)=t;
    T2(1:n1)=T;

    alpha2=alpha(set_t(e1));

    % set threshold values to switch from one type of interpolation to another
    % set an offset for the inverse tangent interpolation of alpha
    thresh1=0.3;
    thresh2=0.7;
    offset=sqrt(2)*10^(-15)-alpha2;

    if logical(alpha2 < thresh1)
        [X IX]=unique(1./(T2+sqrt(2)*10^(-15)));
        t3=interp1(X, t2(IX), 1./(alpha2+sqrt(2)*10^(-15)));
    elseif logical(alpha2 >= thresh1) && logical(alpha2 <= thresh2)
        [X IX]=unique(atan(T2+offset));
        t3=interp1(X, t2(IX), atan(alpha2+offset));
    else
        [X IX]=unique(-1./(T2-1-sqrt(2)*10^(-15)));
        t3=interp1(X, t2(IX), -1./(alpha2-1-sqrt(2)*10^(-15)));
    end


    t11=t2(find(t2 <= t3, 1, 'last' ));
    t22=t2(find(t2 >= t3, 1 ));

    T3=t_alpha(t3, nu);
    error1=abs(T3-alpha2);
    error2=max(abs([t3-t11, t22-t3]));

    count=0;
    flag=0;

    if isequal(alpha2, 0.5)
        t3=0;
        T3=05;
        error1=0;
    else
        
        % % use a while loop to get within the tolerance
        while  (logical(error1 > tol) || logical(error2 > tol)) && (logical( count < max_count) &&  isequal(flag, 0 ))
            count=count+1;
            
            if count > 5
                interp_type='cubic';
            else
                interp_type='linear';
            end
            
            if logical(alpha2 < thresh1)
                [X IX]=unique(1./(T2+sqrt(2)*10^(-15)));
                t3=interp1(X, t2(IX), 1./(alpha2+sqrt(2)*10^(-15)), interp_type);
            elseif logical(alpha2 >= thresh1) && logical(alpha2 <= thresh2)
                [X IX]=unique(atan(T2+offset));
                t3=interp1(X, t2(IX), atan(alpha2+offset), interp_type);
            else
                [X IX]=unique(-1./(T2-1-sqrt(2)*10^(-15)));
                t3=interp1(X, t2(IX), -1./(alpha2-1-sqrt(2)*10^(-15)), interp_type);
            end
    

            % find the nearest neighbors of the interpolated value
            t11=t2(find(t2 <= t3, 1, 'last' ));
            t22=t2(find(t2 >= t3, 1 ));

            [error2 ix2]=max(abs([t3-t11, t22-t3]));

            if ix2 == 1
                pp=min(abs(abs(t3/t11)-1), 0.3);
                t33=t3-pp*(t3-t11);
            else
                pp=min(abs(abs(t3/t22)-1), 0.3);
                t33=t3+pp*(t22-t3);
            end

            q=t_alpha(t33, nu);
            t2(n1+count)=t33;
            T2(n1+count)=q;

            [t2 ixt2]=unique(t2);
            T2=T2(ixt2);
            [T2 ixt2]=unique(T2);
            t2=t2(ixt2);
            T3=q;

            if logical(q <= 1) && logical(q >= -1)

                t11=t2(find(t2 <= t3, 1, 'last' ));
                t22=t2(find(t2 >= t3, 1 ));
                error1=abs(T3-alpha2);
                error2=max(abs([t3-t11, t22-t3]));

            else
                flag=1;
            end


        end

        % Final Interpolation
        if isequal(flag, 0 )

            if count > 5
                interp_type='cubic';
            else
                interp_type='linear';
            end
            
            if logical(alpha2 < thresh1)
                [X IX]=unique(1./(T2+sqrt(2)*10^(-15)));
                t3=interp1(X, t2(IX), 1./(alpha2+sqrt(2)*10^(-15)), interp_type);
            elseif logical(alpha2 >= thresh1) && logical(alpha2 <= thresh2)
                [X IX]=unique(atan(T2+offset));
                t3=interp1(X, t2(IX), atan(alpha2+offset), interp_type);
            else
                [X IX]=unique(-1./(T2-1-sqrt(2)*10^(-15)));
                t3=interp1(X, t2(IX), -1./(alpha2-1-sqrt(2)*10^(-15)), interp_type);
            end
            
        end
    end

    t_out(set_t(e1))=t3;
    T_out(set_t(e1))=T3;
    error1_out(set_t(e1))=error1;
    error2_out(set_t(e1))=error2;
    count_out(set_t(e1))=count;
    
end

