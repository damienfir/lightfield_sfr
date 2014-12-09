clearvars;
% close all;
addpath('util');


%% lf

capture_fname = '../../images/lytro/inclined/pictures';
% capture_fname = '../../images/lytro/slanted_edge/lytro_focus/pictures-2';
% [capture_lf,model] = lf_from_lfp(capture_fname);
% save('capture_lf.mat','capture_lf','model');
load('capture_lf.mat');

% capture_lf = capture_lf(:,:,3:end-2,3:end-2);



%% analysis

pad = 2;
lines_lf = squeeze(capture_lf(:,:,6,pad+1:end-pad));

f = model.focal_length;
b = f;
% a = 1/(1/f - 1/b)
a = f*(0.013);
a = 0;
a = f*(0.04);
D = f / model.fnumber;

% microlens array
d = model.lens_pitch;
p = model.pixel_pitch;
fp = model.z_offset;
bp = fp;

% coordinates
[ny,nx,nu] = size(lines_lf);
scale_x = 1; % ceil(model.lens_size);
scale_u = 1;
newsize = ceil([nx nu] .* [scale_x scale_u]);
x = linspace(ceil(-nx/2),floor(nx/2),newsize(1));
u = linspace(ceil(-nu/2),floor(nu/2),newsize(2));
[X,U] = ndgrid(x,u);
coord = [X(:) U(:)]';

S = [d 0;0 p/bp];
coord_mm = S * coord;

% loop
% rows = [70 102 135 200 ];
rows = 1:size(lines_lf,1);
% depths = [-0.01 0 0.013 0.04];

% MTF50 = [];
bowtie = 0;
for i = 1:numel(rows)
	line_lf = normalized(squeeze(lines_lf(rows(i),:,:)));
% 	a = f * depths(i);
	
% 	A = [1 -a; 0 1];
% 	new_coord_mm = A * coord_mm;
	
	% sampling coordinates
% 	min_coord = min(new_coord_mm, [], 2);
% 	max_coord = max(new_coord_mm, [], 2);
% 	pitch = abs(max_coord - min_coord) ./ ([nx nu] - 1)';
% 	new_coord = new_coord_mm ./ repmat(pitch, 1, size(new_coord_mm,2));
% 	new_coord = new_coord - repmat(min(new_coord,[],2), 1, size(new_coord,2)) + 1;
% 	
% 	new_line_lf = interpn(line_lf, new_coord(1,:), new_coord(2,:), 'linear', 0);
% 	new_line_lf = reshape(new_line_lf, newsize);
	
% 	figure, imshow(line_lf',[])
	grad = imfilter(line_lf',fspecial('sobel')', 'symmetric', 'same');
	bowtie = bowtie + abs(fftshift(fft2(grad)));
% 	figure, imshow(grad,[])
% 	figure, imshow(abs(fftshift(fft2(grad))),[])
% 	break
	
% 	imshow(new_line_lf',[])
% 	pause
	
% 	rendered = sum(new_line_lf, 2) / size(new_line_lf,1);
% 		
% 	len = 20;
% 	span = 4;
% 	d = [0.5 0 -0.5];
% 	w = ones(span,1)/span;
% 	LSF = abs(conv(rendered, d, 'valid'));
% 	LSF(isnan(LSF)) = 0;
% 	LSF = padarray(LSF, 1, 0);
% 	LSF = conv(LSF, w, 'same');
% 	LSF = LSF / sum(LSF(:));
% 	[~,idx] = max(LSF);
% % 	plot(rendered(idx-len:idx+len));
% 	LSF = LSF(idx-len:idx+len);
% 	[SFR,freq] = sfr(LSF);
% 	plot(freq,SFR)
% 	hold on
% 	pause
% 	idx = find(SFR < 0.5)
% 	MTF50 = [MTF50 freq(idx(1))];
end

figure, imshow(bowtie,[]);

% close
% 
% figure, plot(MTF50);
% figure, plot(LSFs)
% figure, imshow(new_line_lf');


% line_lf = line_lf';
% line_1d = line_lf(:);
% idx = sub2ind(size(line_lf), new_coord(2,:),new_coord(1,:));
% line_1d = interp1(line_1d, idx);
% new_line_lf = reshape(line_1d, newsize);