function [xyuv, hex_grid, centers] = lf_coordinates( model )

% lenselet parameters
ls = model.lens_size;
hls = (ls-1) / 2;

% overestimation of hexagonal grid dimension
res_x = floor(model.raw_size(2) / ls);
res_y = floor(model.raw_size(1) / (ls * sqrt(3) / 2));

% get micro-image centers from origin and hexagonal basis
% model.origin = model.origin + [0.5 0.8];
[X,Y] = meshgrid(-res_x:res_x, -res_y:res_y);
hex_grid = [X(:) Y(:)]';
scale = [model.scale(1) 0; 0 model.scale(2)];
centers = repmat(model.origin', 1, numel(X)) + scale * model.basis_hex * hex_grid;

% clip to image borders
valid = centers(1,:) >= hls & centers(1,:) <= model.raw_size(2)-hls & centers(2,:) >= hls & centers(2,:) <= model.raw_size(1)-hls;
hex_grid = hex_grid(:,valid);
centers = centers(:,valid);
hex_grid = hex_grid + repmat(abs(min(hex_grid,[],2)) + 1, 1, size(hex_grid,2));

% compute UV coordinates
uv = linspace(-hls, hls, ceil(model.lens_size));
[U,V] = meshgrid(uv, uv);
UV = [U(:) V(:)]';

% correct for image rotation
% cosa = cos(model.rotation);
% sina = sin(model.rotation);
% m_rot = [cosa -sina; sina cosa];
% UV = m_rot * UV;
UV_full = repmat(UV(:), 1, size(centers,2));

% apply UV coordinates to XY (centers of micro-images)
xyuv = repmat(centers, numel(U), 1) + UV_full;