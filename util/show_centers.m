function show_centers( im, centers)

figure, imshow(im)
hold on
scatter(centers(1,:), centers(2,:), 'blue');
% for i=1:10:numel(centers_x)
% 	rectangle('Position', [centers_x(i)-hls centers_y(i)-hls ls ls], 'EdgeColor', 'red');
% end
zoom(20)