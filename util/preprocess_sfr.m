function [ sfr50_smooth ] = preprocess_sfr( sfr50, window, foc, default )

if nargin > 2
	sfr50(foc) = default;
end
no_value = sfr50 == 0;
sfr50(no_value) = interp1(find(~no_value), sfr50(~no_value), find(no_value), 'linear'); 

sfr50_smooth = sfr50;
sfr50_smooth = conv(sfr50, ones(1,window)/window, 'same');