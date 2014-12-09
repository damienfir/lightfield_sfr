function PSF_4D = psf_ml ( lf, rendered, area )

N = length(lf);

% estimate slope
angle = cell([1 N]);
for i = 1:N
	BW = edge(rendered{i}, 'canny');
	[H, thetas, ~] = hough(BW);
	peaks = houghpeaks(H,10);
	angle{i} = median(thetas(peaks(:,2))) * pi / 180;
end

center = floor(size(lf{1}) / 2) + 1;

tmp = 0;
pad = 2;
[ny,nx,nv,nu] = size(lf{1});
lfsize = (nu);
PSF_4D = zeros(ny,nx,lfsize,lfsize);
for y=center(1)-area:center(1)+area
	for x=center(2)-area:center(2)+area
		for i = 1:N
			lf_image = lf{i};
			uimage = squeeze(lf_image(y,x,:,:));
			uimage = uimage(pad+1:end-pad,:);
			try
				centroids = get_centroids(uimage, angle{i}, pad);
				tmp = lsf(uimage, centroids);
				tmp = tmp * tmp';
				tmp = tmp ./ sum(tmp(:));
				tmp = imresize(tmp, 1/4, 'bilinear');
			catch e
			end
		end
		PSF_4D(y,x,:,:) = tmp;
	end
end

end


function [centroids,p] = get_centroids( uimage, angle, pad )

a = tan(-angle);

[~,~,edges,~] = edge(uimage, 'sobel', [], 'vertical');
% edges = padarray(abs(edges),[0 pad], 0);
edges = abs(edges);

[H,W] = size(edges);
disp = 1:1e-2:W;
y = 1:H;

Y = repmat(y', 1, numel(disp));
X = (Y-H)*a + repmat(disp, numel(y), 1);
diff = sum(interp2(edges, X, Y), 1);

% plot(diff)
% pause(1)

[~, imax] = max(diff);
centroids = X(:, imax);

% abort if edge is too far from center
middle = centroids(floor(end/2));
assert(middle > 2*W/5)
assert(middle < 3*W/5)

p(1) = tan(angle-pi/2);
p(2) = 0;

end
