% clearvars;
% close all;
addpath('util','render');


%% lf

capture_fname = '../../images/lytro/slanted_edge/lytro_focus/pictures-2';
% [capture_lf,model] = lf_from_lfp(capture_fname);
% save('capture_lf.mat','capture_lf','model');
load('capture_lf.mat');

capture_lf = capture_lf(:,:,3:end-2,3:end-2);

% im = squeeze(capture_lf(50:1:150,:,6,:));
% im1 = squeeze(im(1,:,:));
% for i = 2:size(im,1)
% 	im1 = [im1 squeeze(im(i,:,:))];
% end
% figure, imshow(im1',[])
% figure, imshow(abs(fftshift(fft2(im))),[])
% figure, view_lf(capture_lf, 'xyuv');


%% transform

hsize = 163;
% c = floor(size(capture_lf)/2) + 1;
% capture_lf = capture_lf(c(1)-hsize:c(1)+hsize,c(2)-hsize:c(2)+hsize,:,:);
% capture_lf = normalized(capture_lf);


% main lens
f = model.focal_length;
b = f;
% a = 1/(1/f - 1/b) + 1e-2
a = f*(-0.02);
D = f / model.fnumber;

% microlens array
d = model.lens_pitch;
p = model.pixel_pitch;
fp = model.z_offset;
bp = fp;

% coordinates
[ny,nx,nv,nu] = size(capture_lf);
scale_xy = 2;
scale_uv = 1/scale_xy;
newsize = ceil(size(capture_lf) .* [scale_xy scale_xy scale_uv scale_uv])
x = linspace(ceil(-nx/2),floor(nx/2),newsize(2));
y = linspace(ceil(-ny/2),floor(ny/2),newsize(1));
u = linspace(ceil(-nu/2),floor(nu/2),newsize(4));
v = linspace(ceil(-nv/2),floor(nv/2),newsize(3));
[Y,X,V,U] = ndgrid(y,x,v,u);
coord = [X(:) U(:) Y(:) V(:)]';

% transformed coordinates
S = [d 0;0 p/bp];
A = [1 a; 0 1];
S = [S zeros(2); zeros(2) S];
A = [A zeros(2); zeros(2) A];
new_coord_mm = S * coord;
new_coord_mm = A * new_coord_mm;

% sampling coordinates
min_coord = min(new_coord_mm, [], 2);
max_coord = max(new_coord_mm, [], 2);
pitch = abs(max_coord - min_coord) ./ ([nx nu ny nv] - 1)';
new_coord = new_coord_mm ./ repmat(pitch, 1, size(new_coord_mm,2));
new_coord = new_coord - repmat(min(new_coord,[],2), 1, size(new_coord,2)) + 1;

new_capture_lf = interpn(capture_lf, new_coord(3,:), new_coord(1,:), new_coord(4,:), new_coord(2,:), 'linear', 0);
new_capture_lf = reshape(new_capture_lf, newsize);

% figure, view_lf(capture_lf, 'uvxy', []);
% figure, view_lf(new_capture_lf, 'xyuv');
% return

% figure, imshow(squeeze(capture_lf(162,:,6,:))',[])
% figure, imshow(squeeze(new_capture_lf(162,:,6,:))',[])
% figure, imshow(squeeze(new_capture_lf(:,163,:,6))',[])
% return

% figure, imshow(squeeze(sum(sum(capture_lf,3),4)),[]);
figure, imshow(squeeze(sum(sum(new_capture_lf,3),4)),[]);
% set(gca, 'YDir', 'normal')
