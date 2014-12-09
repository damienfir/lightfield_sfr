function im = hex2rec( im_hex_1d, coord )

% shift coordinates to get positive values only
im_size(1) = max(coord(2,:));
im_size(2) = max(coord(1,:));

% store values from hexagonal lattice into 2d image
im_hex = zeros(im_size);
coord_im = sub2ind(im_size, coord(2,:), coord(1,:));
im_hex(coord_im) = im_hex_1d;

% build transformation matrix
m_shear = [1 0 0; 0.5 1 0; 0 0 1];
tform = maketform('affine', m_shear);

% transform and crop image
start = coord(1,coord(2,:) == 1);
if mod(start(1) - im_size(2), 2)
	start(1) = start(1) + 1;
end
im = imtransform(im_hex, tform, 'bilinear', 'XData', [start(1) im_size(2)], 'YData', [1 im_size(1)]);
im = imresize(im, [size(im,2) size(im,2)], 'bilinear');