function LSF = lsf_ml ( lf, rendered, area )

N = length(lf);

% estimate slope
angle = cell([1 N]);
for i = 1:N
	BW = edge(rendered{i}, 'canny');
	[H, thetas, ~] = hough(BW);
	peaks = houghpeaks(H,10);
	angle{i} = median(thetas(peaks(:,2))) * pi / 180;
end

% center = floor(size(lf{1}) / 2) + 1;

tmp = 0;
pad = 2;
[ny,nx,nv,nu] = size(lf{1});
lfsize = (nu*4);
LSF = zeros(nx,lfsize);
y = area(1);
for x=area(2)-area(3):area(2)+area(3)
	x
	for i = 1:N
		lf_image = lf{i};
		uimage = squeeze(lf_image(y,x,:,:));
		uimage = uimage(pad+1:end-pad,:);
		try
			centroids = get_centroids(uimage, angle{i}, pad);
			tmp = lsf(uimage, centroids);
		catch e
		end
	end
	LSF(x,:) = tmp;
end