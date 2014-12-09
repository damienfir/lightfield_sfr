function out = linearize( im, in_values, out_values )

out_values = normalized(out_values);
map = interp1(out_values, in_values, im(:));
out = reshape(map, size(im));
out = normalized(out);