function [ sfr, freq ] = get_sfr( lsf, sampling_period )

if size(lsf,1) < size(lsf,2)
	lsf = lsf';
end


lsf = lsf / sum(lsf);

sfr = abs(fftshift(fft(lsf)));
% figure, plot(SFR);

N = length(lsf);
if mod(N,2) == 0
	q = -N/2:N/2-1;
else
	q = -(N-1)/2:(N-1)/2;
end

% frequencies
freq = q/(N*sampling_period);

zero_freq = find(freq == 0);
freq = freq(zero_freq:end);
sfr = sfr(zero_freq:end);