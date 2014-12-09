function [ sfr, freq, sse, sfr_std ] = get_sfr_fit( lsf, sampling, stdev )

x = 1:numel(lsf);
[cfit,gof] = fit(x', lsf', 'gauss1');
sse = gof.sse;

[sfr,freq] = get_sfr(feval(cfit, x), sampling);

if nargin > 2
	cfit.c1 = cfit.c1 + stdev;
	[sfr_std,~] = get_sfr(feval(cfit,x), sampling);
end