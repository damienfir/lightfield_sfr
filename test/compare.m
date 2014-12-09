clearvars;
addpath('util','sfr','render');

load('data/capture_lf_mod.mat');
load('data/target_lf.mat');
load('data/PSF_4D.mat');

c = floor(size(PSF_4D)/2) + 1;
hs = floor(size(capture_lf) / 2);
PSF_4D = PSF_4D(c(1)-hs(1):c(1)+hs(1), c(2)-hs(2):c(2)+hs(2), c(3)-hs(3):c(3)+hs(3), c(4)-hs(4):c(4)+hs(4));

H = fftn(PSF_4D);
I = fftn(im2uint16(target_lf));
Ip = H .* I;
synth_lf =  normalized(abs(real(ifftshift(ifftn(Ip)))), 0, 100);

figure, view_lf(capture_lf, 'xyuv', []);
% figure, view_lf(target_lf, 'xyuv', [0 1]);
% figure, view_lf(synth_lf, 'xyuv', [0 1]);
% diff_lf = abs(synth_lf - capture_lf);
% figure, view_lf(diff_lf, 'xyuv', [0 1]);

% capture_2d = render_shift(capture_lf, 1);
% target_2d = render_shift(target_lf, 1);
% synth_2d = render_shift(synth_lf, 1);
% 
% figure, imshow(capture_2d, []);
% figure, imshow(target_2d, []);
% figure, imshow(synth_2d, []);

% imwrite(normalized(target_lf_2d,0,100), 'data/img/target_lf_2d.png');
% imwrite(normalized(target_2d,0,100), 'data/img/target_2d.png');
% imwrite(normalized(synth_lf_2d,0,100), 'data/img/synth_lf_2d.png');
% imwrite(normalized(synth_2d,0,100), 'data/img/synth_2d.png');

% [capture_crop,rect] = imcrop(capture_2d);
% close
% target_crop = imcrop(target_2d, rect);
% synth_crop = imcrop(synth_2d, rect);

% [capture_SFR, freq1] = sfr(capture_crop);
% [target_SFR, freq2] = sfr(target_crop);
% [synth_SFR, freq3] = sfr(synth_crop);
% 
% figure
% plot(freq1,capture_SFR, '-', freq2,target_SFR,':', freq3,synth_SFR,'--');
