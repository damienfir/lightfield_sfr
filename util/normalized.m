function out = normalized( in, prc_low, prc_high )

if nargin < 2
	m = min(in(:));
	M = max(in(:));
	out = (in - m) ./ (M - m);
	return
end

in = in - prctile(in(:), prc_low);
in(in < 0) = 0;

out = in / prctile(in(:), prc_high);
out(out > 1) = 1;