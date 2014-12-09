function lf = hex2rec_lf( subapertures, hex_grid )

uv = 1:sqrt(size(subapertures, 1));
[U,V] = meshgrid(uv,uv);
UV = [U(:) V(:)]';

out = hex2rec(subapertures(1,:), hex_grid);

lf = zeros([max(UV,[],2)' size(out)]);
lf(UV(1,1), UV(2,1), :, :) = out;
for ind = 2:size(UV,2)
	lf(UV(2,ind), UV(1,ind), :, :) = hex2rec(subapertures(ind,:), hex_grid);
end
lf = permute(lf, [3 4 1 2]);