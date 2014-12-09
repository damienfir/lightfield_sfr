function im = preprocess( im_raw, model )

fprintf('preprocessing...\n');

im = devignette(im_raw, model);
% im = im_raw;

load('data/oecf.mat');
im = linearize(im, in_values, out_values);