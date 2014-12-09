clearvars;
addpath('load','lf','render','sfr','util');

load('data/PSF_2D.mat');
load('data/PSF_ML.mat');

position = [0 0];

nonzero = 1 - (PSF_2D == 0);
[Y,X] = ind2sub(size(PSF_2D), find(nonzero));

PSF_4D = zeros(size(PSF_ML));
for i = 1:numel(Y)
	PSF_4D(Y(i),X(i),:,:) = PSF_2D(Y(i),X(i)) .* PSF_ML(Y(i)-position(1),X(i)-position(2),:,:);
end

figure
view_lf(PSF_4D, 'xyuv', []);
save('data/PSF_4D.mat', 'PSF_4D');
