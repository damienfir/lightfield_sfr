function [centroids] = get_fit( im )

L = 3;

[H,~] = size(im);

d = 0.5 * [-1 0 1];
g = gausswin(L);

% find edge centroids per line
% centroids = zeros(H,1);
% for i = 1:H
% 	line = im(i,:);
% 	line = conv(line, g, 'same');
% 	derivative = conv(line, d, 'same');
% 
% 	[~, center] = max(derivative);
% 
% 	short = derivative(max(1,center-L):min(end,center+L));
% 	short = short - min(short);
% 	short = short / max(short);
% 
% 	y = 1:length(short);
% 	centroid = y * short' / sum(short);
% 	centroid = centroid + center - L - 1;
% 
% 	centroids(i) = centroid;
% end

% I_f = imfilter(im, fspecial('gaussian', 30, 10));
I_f = im;
[~,~,I_e,~] = edge(I_f, 'sobel', [], 'vertical');

X_i = linspace(1, size(im,2), size(im,2)*20);
Y_i = 1:H;
[X,Y] = meshgrid(X_i,Y_i);
[~,centroids] = max(interp2(I_e,X,Y), [], 2);
centroids = X_i(centroids)';


% fit line to centroids
% y = 1:length(centroids);
% p = polyfit(centroids', y, 1)
% angle = atan(p(1));
