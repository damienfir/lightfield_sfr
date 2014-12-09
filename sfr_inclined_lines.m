%% load light field

clearvars;
close all;
addpath('load','util','sfr','lib','lf');

warning('off','MATLAB:interp1:ppGriddedInterpolant');
warning('off','stats:gmdistribution:FailedToConverge');

% load('data/inclined_lines.mat');

fname = '../../images/lytro/inclined_lines/lightbox/thin-2';
[im, model, im_raw] = load_lfp(fname);
[xyuv, hex_grid, ~] = lf_coordinates(model);
% save('data/inclined_lines.mat','im','model','xyuv','hex_grid');

uimages = extract_uimages(im, xyuv);
lf = hex2rec_lf(uimages, hex_grid);


%% detect lines

subimage = sum(sum(lf,4),3) ./ numel(lf(1,1,:,:));

BW = edge(subimage, 'sobel', 0.15, 'vertical');

[H, thetas, rhos] = hough(BW);
peaks = houghpeaks(H, 20, 'Threshold', 0.55*max(H(:)));
R = rhos(peaks(:,1));
T = thetas(peaks(:,2));

save('data/detected_lines.mat','subimage','H','R','T');


%% microlens LSF

load('data/detected_lines.mat');

% parameters
step = 1;
pad = 2;

% offset coordinates
start_x = 150;
start_y = 250;

[ny,nx,nv,nu] = size(lf);
T_rad = T * pi / 180;
uimage_shape = [10 10];

size_x = max(hex_grid(1,:));
size_y = max(hex_grid(2,:));
offset_x = min(hex_grid(1,hex_grid(2,:) == min(hex_grid(2,:))));
x0 = start_x - (start_y + mod(start_y,2))/2 + offset_x;

uimage_fitted = zeros(size_y,size_x,3);
uimage_lsf = zeros(size_y, size_x, 97);

for y = start_y:step:size_y
	fprintf('y = %d\n', y);
	
	x_axial = start_x - (y + mod(y,2))/2 + offset_x;
	lim_x = size_x - (x0 - x_axial);
	
	for x = x_axial:lim_x
		
		uimage_idx = find(hex_grid(1,:) == x & hex_grid(2,:) == y);
		if numel(uimage_idx) == 0, continue, end
		
		xy =  xyuv([101 100],uimage_idx)' .* size(subimage) ./ size(im);
		x_lines = (R - xy(2) * sin(T_rad)) ./ cos(T_rad);
		angle = interp1(x_lines, T, xy(1), 'linear', 'extrap');
		
		uimage = reshape(uimages(:,uimage_idx), uimage_shape);
		uimage = uimage(pad+1:end-pad,pad+1:end-pad);
		
		[lsf,out] = get_uimage_lsf(uimage, angle);
		uimage_fitted(y,x,:) = out;
		uimage_lsf(y,x,:) = lsf;
		[y x]
		imwrite(uimage, sprintf('data/img/uimages/%d_%d.png', y, x));
	end
end

save('data/uimage_lsf_fitted.mat','uimage_lsf','uimage_fitted');


%% classification

load('data/uimage_lsf_fitted.mat');

n_rows = size(uimage_fitted,1);

valid_uimages = zeros(size_y,size_x);
invalid_uimages = valid_uimages;
gmm_rows = cell(1,n_rows);

for y = 1:n_rows
	fprintf('y = %d\n', y);
	
	fitted_y = squeeze(uimage_fitted(y,:,:));
	
	centered_edges = find(fitted_y(:,2) > 0.4 & fitted_y(:,2) < 0.6);
	valid = fitted_y(centered_edges, [1 3]);
	if numel(centered_edges) == 0, continue, end

	gmm = gmdistribution.fit(valid, 2, 'Regularize',1e-3,'Replicates',10);
	if gmm.Converged == 0
		fprintf('Did not converge at y = %d\n', y);
		noconverged = true;
	end
	
	idx = cluster(gmm,valid);
	[~,low_error_class] = min(gmm.mu(:,2));
	low_sigma = gmm.mu(low_error_class, 1);
	
	valid_edges = idx == low_error_class;
	valid_uimages(y,centered_edges(valid_edges)) = 1;
	invalid_uimages(y,centered_edges(~valid_edges)) = 1;
	
	gmm_rows{y} = gmm;

end

save('data/classification.mat','valid_uimages','invalid_uimages','gmm_rows');


%% compute SFR

load('data/classification.mat');
load('data/uimage_lsf_fitted.mat');

sfr_rows = zeros(size(uimage_lsf,1), ceil(size(uimage_lsf,3)/2));
for y = 1:size(sfr_rows,1)
	fprintf('y = %d\n', y);
	
	valid = logical(squeeze(valid_uimages(y,:)));
	if sum(valid) == 0, continue, end
	
	lsf_line = squeeze(uimage_lsf(y,:,:));
	lsf_line = lsf_line(valid,:);
	
	if size(lsf_line,1) == 1
		lsf_mean = lsf_line;
		lsf_std = zeros(size(lsf_mean));
	else
		[~,centers] = max(lsf_line,[],2);
		
		[H,W] = size(lsf_line);
		HW = floor(W/2);
		[XX,YY] = meshgrid(-HW:HW, 1:size(lsf_line,1));
		X_center = XX + repmat(centers, 1, size(lsf_line,2));
		lsf_line_centered = interp2(lsf_line, X_center, YY, 'linear', 0);
		
		lsf_mean = mean(lsf_line_centered,1);
		lsf_mean = lsf_mean / sum(lsf_mean);
	end
	
	stdev = std(uimage_fitted(y,valid,1));
	[sfr,freq,sse,sfr_std] = get_sfr_fit(lsf_mean, 1/4, stdev);
	
	if sse > 0.0020, continue, end
	
	sfr_rows(y,:) = sfr;
	sfr_rows_std(y,:) = sfr_std;
end

save('data/sfr_rows.mat','sfr_rows','sfr_rows_std','freq');
