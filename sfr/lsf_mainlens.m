function [ LSF ] = lsf_mainlens( im, centroids )
% im: OECF corrected, luminance, cropped picture, vertical edge 

[H,W] = size(im);

% add shifts to generate ESF
factor = 4;
[X,Y] = meshgrid(linspace(-W/2,W/2,W*factor), 1:H);
X_centered = X + repmat(centroids, 1, size(X,2));
im_centered = interp2(im, X_centered, Y);
ESF = mean(im_centered, 1)';

% pad head and tail of ESF
[~,imin] = min(ESF);
[~,imax] = max(ESF);
left = min(imin,imax);
right = max(imin,imax);
ESF(1:left) = ESF(left);
ESF(right:end) = ESF(right);

% line spread function
span = factor;
d = [0.5 0 -0.5];
w = ones(span,1)/span;
LSF = abs(conv(ESF, d, 'valid'));
LSF(isnan(LSF)) = 0;
LSF = padarray(LSF, 1, 0);
LSF = conv(LSF, w, 'same');
LSF = LSF / sum(LSF(:));