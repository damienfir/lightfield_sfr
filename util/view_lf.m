function [ rendered ] = view_lf( lf, type, varargin )

lf_size = size(lf);
if strcmp(type, 'xyuv');
	perm = [3 1 4 2];
else strcmp(type, 'uvxy');
	perm = [1 3 2 4];
end
	
rendered = reshape(permute(lf,perm), lf_size(1)*lf_size(3), lf_size(2)*lf_size(4));

range = [];
if ~isempty(varargin)
	range = varargin{1};
end

imshow(rendered, range);
axis on;