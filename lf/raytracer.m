clearvars;
addpath('util');


% ----- input -----
target_fname = 'data/slanted.png';
capture_fname = '../../images/lytro/slanted_edge/close';


% ----- parameters -----
hsize = [40 3];
capture_shift = [0 -42 0 0];
target_distance = 10e-2;
target_shift = [0 0];
scale = 1;
rotation = 6;
target_h = 8e-2;
integrate = true;
vignetting = false;


% ----- load -----
% [capture_lf,model] = lf_from_lfp(capture_fname);
% save('data/capture_lf.mat','capture_lf','model');
load('data/capture_lf.mat');
black_level = min(capture_lf(:));
white_level = max(capture_lf(:));
center = floor(size(capture_lf)/2) + 1 + capture_shift;
capture_lf = capture_lf(center(1)-hsize(1):center(1)+hsize(1),center(2)-hsize(1):center(2)+hsize(1),center(3)-hsize(2):center(3)+hsize(2),center(4)-hsize(2):center(4)+hsize(2));
target_im = im2double(rgb2gray(imread(target_fname)));
target_im = (target_im - black_level) ./ (white_level - black_level);% * max(capture_lf(:)) / max(target_im(:));
target_im = rot90(target_im,2);


% ----- main lens -----
f = model.focal_length;
b = f;	% focus @ infinity
a = target_distance;
D = f / model.fnumber;


% ----- microlens array -----
d = model.lens_pitch;
p = model.pixel_pitch;
fp = model.z_offset;
bp = fp;


% ----- target parameters ------
[h,w] = size(target_im);
target_h = target_h * scale;
target_w = target_h * scale;
px_pitch = target_h/h;
target_center = [h/2+target_shift(1) w/2+target_shift(2)];


% ----- MLA coordinates -----
[ny,nx,nv,nu] = size(capture_lf);
x = (1:nx) - nx/2 - 0.5;
y = (1:ny) - ny/2 - 0.5;
u = (1:nu) - nu/2 - 0.5;
v = (1:nv) - nv/2 - 0.5;
[Y,X,V,U] = ndgrid(y,x,v,u);
coord = [X(:) U(:) Y(:) V(:)]';


% ----- transformed coordinates -----
S = [d 0;0 p/bp];
A_lens = [1 -b; 0 1];
A_target = [1 -a; 0 1] * [1 0; 1/f 1];
S = [S zeros(2); zeros(2) S];
A_lens = [A_lens zeros(2); zeros(2) A_lens];
A_target = [A_target zeros(2); zeros(2) A_target];
new_coord_lens = A_lens * S * coord;
new_coord_mm = A_target * new_coord_lens;


% ----- target coordinates -----
rot = rotation * pi / 180;
A_rot = [cos(rot) -sin(rot); sin(rot) cos(rot)];
coord_target = A_rot \ new_coord_mm([1 3], :);
coord_target = coord_target / px_pitch;
coord_target = coord_target + repmat(target_center', 1, size(coord_target,2));


% ----- integration area -----
if integrate
	radius = ((d/2) * (a - f) / f) / px_pitch;
else
	radius = 0;
end
rad_xy = -floor(radius):floor(radius);
[area_y,area_x] = ndgrid(rad_xy, rad_xy);
area = [area_x(:) area_y(:)]';


% ----- cropping -----
min_px = min(coord_target,[],2);
size_px = max(coord_target,[],2) - min_px;
target_im = imcrop(target_im, [min_px(1)+1 min_px(2)+1 size_px(1) size_px(2)]);
coord_target = coord_target - repmat(min_px, 1, size(coord_target,2)) + 1;


% ----- vignetting -----
weights = ones(1,size(new_coord_lens,2));
sigma = 1;
if vignetting
	coord_lens = new_coord_lens([1 3],:);
	weights = (1/(sqrt(2)*sigma)) * exp(- (D^2 - sum(coord_lens.^2, 1)) / sigma);
	weights = 1 - normalized(weights, 0, 100);
end


% ----- interpolation -----
target_lf = zeros(1,size(coord_target,2));
N = numel(area_y);
for i = 1:N
	fprintf('processing...%.0f%%\n', i*100 / N);
	XY = round(coord_target + area(i));
	target_lf = target_lf + interp2(target_im, XY(1,:), XY(2,:), 'linear', 0);
end
target_lf = target_lf .* weights;
target_lf = reshape(target_lf / N, size(capture_lf));
% target_lf = normalized(target_lf);


% ----- viewing -----
figure, view_lf(capture_lf, 'uvxy', [0 1]);
figure, view_lf(target_lf, 'uvxy', [0 1]);
save('data/target_lf.mat','target_lf');
save('data/capture_lf_mod.mat','capture_lf');

