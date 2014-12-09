function plot_deadleaves( circles )

% imshow(ones(W,W) * 0.5)
for i = 1:size(circles,2)
	r = circles(3,i);
	rectangle('Position',[circles(1,i)-r,circles(2,i)-r,r*2,r*2], 'Curvature', [1,1],...
		'FaceColor', [1 1 1] * circles(4,i), 'EdgeColor', 'none');
end
axis equal
axis off