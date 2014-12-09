function [ uimages ] = extract_uimages( im, xyuv )

fprintf('extracting micro-images...\n');

xp = xyuv(1:2:end,:);
yp = xyuv(2:2:end,:);

% get interpolated values from coordinates to get subaperture images
uimages = interp2(im, xp(:), yp(:), 'nearest');
uimages = reshape(uimages, size(xp));
