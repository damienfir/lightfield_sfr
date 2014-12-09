%% render image

clearvars;
close all;
addpath('load','lf','render','sfr','util');


load('data/slanted_edge.mat');


image = '../../images/lytro/slanted/distance/pictures-2';
[im_raw, model] = read_lfp(image);
im = preprocess(im_raw, model);
% save('data/slanted_edge.mat', 'im','model');


lf = extract_lf(im, model);
rendered = render_shift(lf, 1);

imwrite(rendered, 'data/slanted_edge_rendered.tif');


%% compute LSF

rendered = im2double(imread('data/slanted_edge_rendered.tif'));

crop = imcrop(rendered);
close

LSF_ML = lsf_mainlens(crop, get_fit(crop));

save('data/LSF_ML.mat','LSF_ML');


%% compute SFR

load('data/LSF_ML.mat');

N = numel(LSF_ML);

[sigma,mu] = gaussfit(1:numel(LSF_ML), LSF_ML);
[SFR_ML,freq_ML] = sfr_gaussian(sigma, model.lens_size/4, N);


sfr0 = find(SFR_ML < 1e-5);
bound = sfr0(2);
pp_ML = interp1(SFR_ML(1:bound),freq_ML(1:bound),'spline','pp');

[SFR_ML_raw,freq] = get_sfr(LSF_ML, model.lens_size/4);

SFR_ML_raw = interp1(freq, SFR_ML_raw, freq_ML, 'spline');
% plot(freq_ML, SFR_ML_raw); %, 'b', freq_ML, SFR_ML, 'r');

save('data/SFR_ML.mat','SFR_ML','freq_ML', 'pp_ML', 'SFR_ML_raw');