clearvars;
% close all;
addpath('util');


%% lf

% capture_fname = '../../images/lytro/inclined/pictures';
capture_fname = '../../images/lytro/slanted_edge/lytro_focus/pictures-2';
[capture_lf,model] = lf_from_lfp(capture_fname);
save('capture_lf.mat','capture_lf','model');
load('capture_lf.mat');


%% rendering

% pad = 2;
% lines_lf = squeeze(capture_lf(:,:,6,pad+1:end-pad));
% [ny,nx,nu] = size(lines_lf);
[ny,nx,nv,nu] = size(capture_lf);
res_x = nx * nu;
res_y = ny * nv;

% row = 100;
% line_lf = normalized(squeeze(lines_lf(row,:,:)));

M = 2;
% rendered = zeros(1,res_x);
% for i = 0:res_x-1
% 	p = floor(i / nu) + 1;
% 	qp = (i/nu - p) * M + 0.5*(nu - M) + 1;
% 	
% 	rendered(i+1) = interpn(line_lf, p, qp, 'linear', 0);
% end

x = 0:res_x-1;
y = 0:res_y-1;
[Y,X] = ndgrid(y,x);
YX = [Y(:) X(:)]';
YXp = floor(YX / nu) + 1;
VUp = (YX / nu - YXp) * M + 0.5*(nu - M) + 1;

% rendered = 0;
% for i = -1:1
% 	for j = -1:1
% 		[i j]
% 		ij = repmat([i j]', 1, size(YXp,2));
% 		YXpp = YXp + ij;
% 		VUpp = VUp - ij * M;
% 		rendered = rendered + interpn(capture_lf, YXpp(1,:), YXpp(2,:), VUpp(1,:), VUpp(2,:), 'linear', 0);
% 	end
% end
% rendered = reshape(rendered, res_y, res_x) ./ 25;

rendered = interpn(capture_lf, YXp(1,:), YXp(2,:), VUp(1,:), VUp(2,:), 'nearest', 0);
rendered = reshape(rendered, res_y, res_x);

% figure, imshow(line_lf');
figure, imshow(rendered,[])
