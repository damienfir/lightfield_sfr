function out = render_shift( lf, alpha )

sub = permute(lf, [3 4 1 2]);
[U,V,Y,X] = size(sub);

% determine shifts amount
value = 1 - 1/alpha;

% integrate subaperture images for all UV with shift
uc = floor(U / 2) + 1;
vc = floor(V / 2) + 1;
out = zeros(Y,X);
for u = 1:U
	for v = 1:V
		u_shift = value * (u - uc);
		v_shift = value * (v - vc);
		trans = maketform('affine', [1 0 0; 0 1 0; v_shift u_shift 1]);
		out = out + imtransform(squeeze(sub(u,v,:,:)), trans, 'XData', [1 X], 'YData', [1 Y]);
% 		out = out + squeeze(sub(u,v,:,:));
	end
end
out = out / (U*V);
