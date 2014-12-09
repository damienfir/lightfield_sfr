function circles = generate_deadleaves( W, N )

addpath('lib/export');

% W = 500;
% N = 50000;

lmin = 0.25;
lmax = 0.75;
rmin = 1e-3;
rmax = W;

grays = rand(1,N) * (lmax - lmin) + lmin;

radii = linspace(rmin, rmax, 500);
r_dist = cumsum(1./radii.^3 - 1./rmax.^3);
r_dist = (r_dist - min(r_dist)) ./ (max(r_dist) - min(r_dist));

r = repmat(rand(N,1), 1, numel(r_dist));
[~,idx] = min(abs(r - repmat(r_dist, size(r,1), 1)), [], 2);
radii = radii(idx);

x = rand(1,N) * W;
y = rand(1,N) * W;

circles = [x; y; radii; grays];

% im = export_fig('fig.tif','-r500');
% close
% figure, imshow(abs(fftshift(fft2(im))),[0 1e4]);
