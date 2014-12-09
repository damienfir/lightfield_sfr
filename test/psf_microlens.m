clearvars;
close all;
addpath('load','lf','render','sfr','util');


%%

folder = '../../images/lytro/slanted_lines/shift';

N = 4;
for i = 1:N
	i
	[im_raw, model] = load_images(fullfile(folder, int2str(i)));
	
	im = preprocess(im_raw, model);
	lf = extract_lf(im, model);
	lfs{i} = lf;
	clear im im_raw;
	
	ren = render_FSR(lf, 0);
	rendered{i} = ren;
	
	clear lf ren;
end
save('data/lfs_rendered.mat', 'lfs', 'rendered');


%%

load('data/lfs_rendered.mat');

area = 10;

PSF_ML = psf_ml(lfs, rendered, area);

figure, view_lf(PSF_ML(164-area:164+area,164-area:164+area,:,:),'xyuv');
save('data/PSF_ML.mat','PSF_ML');

%%

load('data/lfs_rendered.mat');

LSF_uL = lsf_ml(lfs, rendered);

figure, imshow(LSF_uL',[])
save('data/LSF_uL.mat','LSF_uL');
