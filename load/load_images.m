function [ im, model, im_raw ] = load_images( root_dir )

files = dir(fullfile(root_dir, '*.raw'));
nfiles = size(files,1);

im = 0;
im_raw = 0;
for i = 1:nfiles
	fname = files(i).name;
	[I,model] = read_lfp(fullfile(root_dir, fname(1:end-14)));
% 	im_raw = im_raw + I;
% 	im = im + preprocess(I,model);
	im = im + I;
end

im = im / nfiles;
% im_raw = im_raw / nfiles;
% im = normalized(im / nfiles);