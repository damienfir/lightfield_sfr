function deltas = build_delta( PSF4D )

% [val, vmax] = max(PSF4D, [], 4);
% [~, umax] = max(val, [], 3);
% vmax = vmax(umax);

deltas = zeros(size(PSF4D));
% [X,Y] = meshgrid(1:size(deltas,2), 1:size(deltas,1));

% deltas(Y(:),X(:),umax(:),vmax(:)) = 1;


for i = 1:size(deltas,1)
	for j = 1:size(deltas,2)
		[val,vmax] = max(squeeze(PSF4D(i,j,:,:)),[],2);
		[~,umax] = max(val,[],1);
		deltas(i,j,umax,vmax(umax)) = 1;
	end
end