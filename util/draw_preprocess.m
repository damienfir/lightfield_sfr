clearvars

%% sfr50 plot

image = 'thin-4';

load(fullfile('data',image,'sfr_rows.mat'));
load('data/SFR_ML.mat');
load(fullfile('data',image,'classification.mat'));
load(fullfile('data', image, 'draw.mat'));

sfr50 = zeros(2,size(sfr_rows,1));
sfr50_std = zeros(2,size(sfr_rows,1));
for y = 1:size(sfr50,2)
	sfr_row = squeeze(sfr_rows(y,:));
	if sum(sfr_row) == 0, continue, end
	sfr0 = find(sfr_row < 1e-5);
	bound = sfr0(2);
	sfr50(1,y) = ppval(interp1(sfr_row(1:bound), freq(1:bound), 'linear', 'pp'), 0.5);
	sfr50(2,y) = ppval(interp1(sfr_row(1:bound), freq(1:bound), 'linear', 'pp'), 0.1);
	sfr50_std(1,y) = ppval(interp1(sfr_rows_std(y,1:bound), freq(1:bound), 'linear', 'pp'), 0.5);
	sfr50_std(2,y) = ppval(interp1(sfr_rows_std(y,1:bound), freq(1:bound), 'linear', 'pp'), 0.1);
end

% range = 53:78;
w = 15;
sfr50_smooth = sfr50;
sfr50_smooth(1,:) = preprocess_sfr(sfr50(1,:), w, range, ppval(pp_ML, 0.5));
sfr50_smooth(2,:) = preprocess_sfr(sfr50(2,:), w, range, ppval(pp_ML, 0.1));
sfr50_std_smooth(1,:) = preprocess_sfr(sfr50_std(1,:), w, range, ppval(pp_ML, 0.5));
sfr50_std_smooth(2,:) = preprocess_sfr(sfr50_std(2,:), w, range, ppval(pp_ML, 0.1));
sfr50_smooth(:,end-floor(w/2):end) = NaN;

diff = sfr50_smooth - sfr50_std_smooth;

x = 1:size(sfr50_smooth,2);
data = [x; sfr50_smooth; diff];

dlmwrite(['data/plot/sfr50_' image], data);


%% # of valid uimages

image = 'thin-3';

load(fullfile('data',image,'classification.mat'));
load(fullfile('data', image, 'draw.mat'));

n_uimages = sum(valid_uimages,2) .* 2;
n_uimages = preprocess_sfr(n_uimages, 20, range, 25);
n_uimages(end-10:end) = NaN;

data = [1:numel(n_uimages); n_uimages'];

dlmwrite(['data/plot/n_uimages_' image], data);


%% SFR curves

image = 'thin-2';
load(fullfile('data/',image,'/sfr_rows.mat'));

idx = [41 200];

data = [freq; sfr_rows(idx(1),:); sfr_rows(idx(2),:)];

dlmwrite('data/plot/sfr_ul', data);


%% detected lines

load('data/detected_lines.mat');

T_rad = T * pi / 180;
y = 1:size(subimage,1);
imshow(subimage)
hold on
for i = 1:numel(R)
	x = (R(i) - y .* sin(T_rad(i))) ./ cos(T_rad(i));
	plot(x,y, 'r', 'LineWidth',2)
end

print('hough_lines.tif','-dtiff');


%% scatter plot classification

load('data/thin-2/uimage_lsf_fitted.mat');
load('data/thin-2/classification.mat');

rows = [280 70];

for i = 1:2
	row = rows(i);
	cluster1 = squeeze(uimage_fitted(row, logical(squeeze(valid_uimages(row,:))), :));
	cluster2 = squeeze(uimage_fitted(row, logical(squeeze(invalid_uimages(row,:))), :));
	data = [];
	data(1:2,1:size(cluster1,1)) = cluster1(:,[1 3])';
	data(3:4,1:size(cluster2,1)) = cluster2(:,[1 3])';
	data(data == 0) = NaN;
	
	dlmwrite(['data/plot/clusters' int2str(i)], data);
end


%% SFR ML

load('data/SFR_ML.mat');

data = [freq_ML; SFR_ML_raw];
dlmwrite('data/plot/sfr_ml', data);

