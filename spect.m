% out = spect(data, K, beta, out_form, samp_freq)
%
% create quick spectral analysis plots
%
% Inputs:
%      data - the data for spectral analysis
%         K - averaging parameter, explained below
%      beta - beta value for the Kaiser window
%  out_form - spectral analysis option
% samp_freq - data sampling frequency
%
% Outputs:
%       out - calculated spectral estimate in form specified by out_form
%
% Averaging Parameter:
% The spectra are smoothed by averaging over windows 1/K times the full
% length of data. This smoothing method is based upon a technique described
% in section 13.4 of "Numerical Recipies in C++", Second Edition.
%
% Windowing:
% Each of the above windows are multiplied with a Kaiser window with the
% provided window beta value given by the beta input parameter.
%
% Output Format Options:
%   'as'  -  amplitude spectrum
%   'ps'  -  power spectrum
%  'asd'  -  amplitude spectral density
%  'psd'  -  power spectral density
%  'rms'  -  integrated rms motion
%
% Matthew Warden
% mattwarden@gmail.com
% 14 July 2010
%

function [out, freqs_out] = spect(data, K, beta, out_form, samp_freq)

% Set default values for unspecified input parameters
switch nargin
    case 1
        K = 1;
        beta = 1;    
        out_form = 'ps';
        samp_freq_set = 0;
    case 2
        beta = 1;    
        out_form = 'ps';
        samp_freq_set = 0;
    case 3
        out_form = 'ps';
        samp_freq_set = 0;
    case 4
        samp_freq_set = 0;
    case 5
        samp_freq_set = 1;
    otherwise
        error('Unexpected number of input arguments');   
end

if (strcmp(out_form, 'asd') || strcmp(out_form, 'psd')) && ~samp_freq_set
    error('Sampling frequency must be set to calculate spectral densities');
end

% Depending upon what output format we want, we typically want to normalise
% the signal differently. This selects sensible options for that choice.
% The value of win_norm has two effects. It determines how the Kaiser
% window is normalised, and it determines how the two sided spectrum is
% turned into a single sided spectrum.
% Further information on these effects can be found later in this script.
switch out_form
    case {'as' 'ps'}
        win_norm = 'amp';
    case {'asd' 'psd' 'rms'}
        win_norm = 'pow';
    otherwise
        error(['out_form value not recognised.\n' ...
            'it should be one of the following values:\n' ...
            '  ''as'', ''ps''\n  ''asd'', ''psd''\n  ''rms''']);
end

% transpose the data array if required on the assumption that the length of
% the data is larger than the number of channels.
if size(data, 2) > size(data, 1)
    data = data';
end
% s is the length of the full data array
s = size(data, 1);

%The dividing by two inside the 'floor' and then multiplying by two again
%afterwards is to make sure that M/2 is an integer for later on when we use
%this as an index (which must be an integer)

%This is the size of the subsets of data.
N = 2*floor( s / (2*K) );

%This is half the size of the subsets of data. It is how many FFT bins we
%have in a single sided spectrum
Nss = floor(  s / (2*K));



%% Create a normalised window function

% Make the window function
win = kaiser(N, beta);

% Normalise the window to preserve either the peak amplitude of single
% frequency signals, or to preserve the power and thus the level of
% broadband signals such as a noise floor.
switch win_norm
    case 'amp'
        % Calculate the scaling factor (coherent gain) of the window
        cg = mean(win);
        % Normalise the window so that its coherent gain is 1.
        win = win / cg;
    case 'pow'
        % Calculate the power amplification factor of the window
        % NB I'm unaware of a standard term describing what I mean by
        % 'power amplification factor' therefore this term is made up.
        paf = sqrt(mean(win.^2));
        % Normalise the window so that its power amplification factor is 1.
        win = win / paf;
end

%% Compute averaged power spectra

% Initialise an array to store averaged amplitude spectra in.
av_as_ss = zeros(N/2, size(data, 2));

% Iterate over the data channels
for p = 1:size(data, 2)
    
    % Iterate over the windowed subsets of data to be averaged together
    for offset = 1:N/2:s-N+1
        
        % Array indices for this windowed subset of data
        data_range = (offset:offset+N-1)';

        % Obtain a windowed subset of the data
        dat_win = data(data_range, p) .* win;
        
        % Calculate the power spectrum of the windowed data
        as = abs(fft(dat_win) / N);

        % Remove the negative frequencies
        as_ss = as(1:floor(end/2));

        % Add this spectra to the array in which we're summing up spectras
        av_as_ss(:, p) = av_as_ss(:, p) + as_ss;
    end
    
    % Change the level of the single sided spectrum to represent either
    % the amplitude or the power.
    switch win_norm
        case 'amp'
            % multiply the remaining positive frequencies by 2^2.
            av_as_ss = av_as_ss * 2;
        case 'pow'
            % multiply the remaining positive frequencies by 2.
            av_as_ss = av_as_ss * sqrt(2);
    end
    % NOTE: This doesn't treat the DC component correctly.
    
    % We have summed up the spectra from windowed subsets of data.
    % Now compute the mean by dividing by the number we have summed over.
    av_as_ss(:, p) = av_as_ss(:, p) / (2*K - 1);
    
    %Compute the averaged power spectrum as the square of the averaged
    %amplitude spectrum
    av_ps_ss = av_as_ss.^2;

end

%normalised frequencies. Here 1 is the Nyquist frequency for whatever
%sampling rate we used.
norm_freqs = (0:1/Nss:1-1/Nss)';
if samp_freq_set
    freqs = norm_freqs * samp_freq / 2;
else
    freqs = norm_freqs;
end

switch out_form
    case 'as'
        % Plot the amplitude spectrum
        semilogy(freqs, av_as_ss);
        ylabel('signal amplitude');
        for_out = av_as_ss;
    case 'ps'
        % Plot the power spectrum
        semilogy(freqs, av_ps_ss);
        ylabel('signal power');
        for_out = av_ps_ss;
    case 'asd'
        % Normalise by dividing by Delta_f
        delta_f = samp_freq ./ N;
        av_asd_ss = av_as_ss ./ delta_f;
        
        semilogy(freqs, av_asd_ss);
        ylabel('amplitude spectral density');
        for_out = av_asd_ss;
    case 'psd'
        % Normalise by dividing by Delta_f
        delta_f = samp_freq ./ N;
        av_psd_ss = av_ps_ss ./ delta_f;
        
        semilogy(freqs, av_psd_ss);
        ylabel('power spectral density');
        for_out = av_ps_ss;
    case 'rms'
        % Compute the integrated RMS variation
        ips = cumsum(av_ps_ss(end:-1:2));
        ips = ips(end:-1:1);
        rms = sqrt(ips);
        
        loglog(freqs(2:end), rms);
        ylabel('integrated RMS variation');
        for_out = rms;
    otherwise
end

if samp_freq_set
    xlabel('frequency');
else
    xlabel('frequency / Nyquist frequency');
end

% If a return is requested, provide the data from the plot.
if nargout > 0
    out = for_out;
    freqs_out = freqs;
end

% To Do:
% Don't plot if a return is requested?



