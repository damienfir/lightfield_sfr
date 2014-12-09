function [ res ] = FSR_slice( im4d_fft, alpha )
%FSR_SLICE Extracts a slice from a color plane
% By C. Marx & L. Baboulaz - EPFL Spring 2013


[m,n,p,q] = size(im4d_fft);
center = floor(size(im4d_fft)/2) + 1;

% Translation parameter
t = alpha;

% Find the coordinates of the 2D slice
% From T. Georgiev (tutorial CVPR 2008)
[x,y] = meshgrid(1:n,1:m);
v = t * (x - center(2)) / n + center(4);
u = t * (y - center(1)) / m + center(3);

% Resample 4D light field along the 2D slice
sliced = interpn(im4d_fft,y,x,u,v,'linear');

% Set NaN values to zero
sliced(isnan(sliced)) = 0;

% Compute inverse 2D FFT to get the image
res = real(ifft2(ifftshift(sliced)));

end