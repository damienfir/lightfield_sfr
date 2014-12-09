%% Read file

% clearvars;

addpath('load','lf','render','sfr','util');

% image = '../../images/lytro/siemens/img00007';
% image = '../../images/lytro/macro/img00143';
% image = '../../images/lytro/misc/img00002';
% image = '../../images/lytro/slanted/img00013';
% image = '../../images/lytro/depth/pictures-7';
% image = '../../images/lytro/slanted_depth/pictures-1';
% image = '../../images/lytro/depth/pictures-4';
% image = '../../images/lytro/hyperfocal/img00033';
% image = '../../images/lytro/slanted_lines/defocus2/pictures_defocus2-0';
% image = '../../images/lytro/slanted/distance/pictures-2';
% image = '../../images/lytro/slanted_lines/shift-test/pictures-2'; % 4,5,6 (~3mm)
% image = '../../images/lytro/slanted_lines/hyperfocal/pictures-5';
% image = '../../images/lytro/deadleaves/infinity';
% image = '../../images/lytro/slanted_edge/lytro_focus/pictures-1';
image = '../../images/lytro/inclined_lines/uniform/pictures';

[im_raw, model] = read_lfp(image);

figure, imshow(im_raw,[])


%% load image stack
% clearvars;

[im, model, im_raw] = load_images('../../images/lytro/slanted_lines/noise');
figure, imshow(im)

%% Pre-processing

im = preprocess(im_raw, model);
figure, imshow(im)


%% Extract light-field

lf = extract_lf(im, model);
figure, view_lf(lf,'xyuv');

%% Render shift

rendered = render_shift(lf, 1.5);

figure, imshow(rendered,[]);


%% Compute FT

fsr = FSR_preprocess(im2uint16(lf));


%% Render

rendered = FSR_compute(fsr, 0);

% load('oecf.mat');
% rendered = linearize(rendered, in_values, out_values);

figure, imshow(rendered,[])


%% MTF

figure
crop = imcrop(ren);
close
centroids = get_fit(crop);
PSF = lsf(crop, centroids);
[SFR,freq] = sfr(PSF);
% figure, imshow(PSF,[])
plot(freq,SFR);
axis tight


%% View

figure, view_lf(lf, 'xyuv');
figure, view_lf(lf, 'uvxy');


%% Render patch
lf = capture_lf;
c = floor(size(lf)/2) + 1;
M = 3;
v = linspace(floor(c(3)-M/2),floor(c(3)+M/2), 11);
u = linspace(floor(c(4)-M/2),floor(c(4)+M/2), 11);
[Y,X,V,U] = ndgrid(1:size(lf,1), 1:size(lf,2), v, u);
lf_r = interpn(lf, Y,X,V,U);
figure
ren = view_lf(lf_r,'xyuv');
