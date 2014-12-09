%% 
clearvars;
close all;
addpath('load','lf','render','sfr','util');

image = '../../images/lytro/slanted/distance/pictures-2';
[im_raw, model] = read_lfp(image);
im = preprocess(im_raw, model);
lf = extract_lf(im, model);
rendered = render_shift(lf, 1);

imwrite(rendered, 'data/slanted_edge_rendered.tif');


%% 

rendered = im2double(imread('data/slanted_edge_rendered.tif'));

crop = imcrop(rendered);
close

LSF_ML = lsf_mainlens(crop, get_fit(crop));
save('data/LSF_ML.mat','LSF_ML');


%%

PSF_2D = LSF * LSF';
PSF_2D = PSF_2D ./ sum(PSF_2D(:));
PSF_2D = imresize(PSF_2D, 1/4, 'bilinear');

pad = (size(rendered) - size(PSF_2D)) / 2;
PSF_2D = padarray(PSF_2D, pad, 0);

figure, imshow(PSF_2D,[])
save('data/PSF_2D.mat','PSF_2D');
