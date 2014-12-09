function [SFR,freq] = sfr_gaussian(sigma, sampling_period, factor, N)

% w = linspace(0,4,N);
% SFR = exp(-w.^2 * sigma.^2 * 0.5);

x = linspace(-N,N,2*N+1);
LSF_fit = 1/(sqrt(2*pi)*sigma) * exp(-0.5*(x/sigma).^2);

[SFR,freq] = sfr(LSF_fit, sampling_period, factor);
