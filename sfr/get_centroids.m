function [centroids,p] = get_centroids( uimage, angle )
% angle in degrees

m = tan(angle*pi/180);

[~,~,grad,~] = edge(uimage, 'sobel', [], 'vertical');
grad = abs(grad);

[H,W] = size(grad);
b = linspace(0, -m*W, W*4); % min and max b value
y = 1:H;

Y = repmat(y', 1, numel(b));
X = (Y - repmat(b, numel(y), 1)) / m;

diff = sum(interp2(grad, X, Y, 'linear', 0), 1);
figure, imshow(interp2(uimage, X, Y, 'linear', 0),[])
return

[~, imax] = max(diff);
centroids = X(:, imax);

figure
imshow(uimage)
hold on
scatter(centroids, y);

% abort if edge is too far from center
middle = centroids(floor(end/2));
assert(middle > 2*W/5)
assert(middle < 3*W/5)