function [SFR,freq] = sfr_gaussian(sigma, sampling_period, N)

x = linspace(-N,N,2*N+1);
LSF_fit = 1/(sqrt(2*pi)*sigma) * exp(-0.5*(x/sigma).^2);

[SFR,freq] = get_sfr(LSF_fit, sampling_period);
