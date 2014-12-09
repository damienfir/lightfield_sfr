clearvars;
addpath('util','sfr');

load('data/PSF_4D.mat');

center = floor(size(PSF_4D)/2) + 1;
PSF = squeeze(PSF_4D(center(1),:,center(3),:));

figure
imagesc(abs(fftshift(fft2(PSF'))))

figure
sfr_2d(PSF);
