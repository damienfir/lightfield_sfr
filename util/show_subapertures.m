function show_subapertures( im, model )

[coord, centers] = lenselet_centers(model);
[subapertures, UV] = extract_subapertures(im, centers, model);

out = hex2rec(subapertures(1,:), coord);
for ind = 2:N
	out = hex2rec(subapertures(ind,:), coord);
end

end

