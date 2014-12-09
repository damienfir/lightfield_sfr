clearvars;
addpath('render','sfr');

load('data/PSF_4D.mat');

range = [0.2 0.5 1];
color = ['r' 'g' 'b'];

for i = 1:numel(range)
	H = render_shift(PSF_4D, range(i));
	imwrite(normalized(H,0,100), ['data/img/filter_at_' num2str(range(i)) '.png']);
	[SFR,freq] = sfr(H);
	plot(freq, SFR, color(i));
	hold on
end