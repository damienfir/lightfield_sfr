function im_devignetted = devignette( im, model )

white_img = find_match(model);
black = min(white_img(:));
white = prctile(white_img(:),99);
white_img = (white_img - black) ./ (white - black);
im = (im - black) ./ (white - black);

im_devignetted = im ./ white_img;
% im_devignetted = im;

im_devignetted = min(1, max(0, im_devignetted));

end


function [ raw ] = find_match( model )

calibfolder = '../../data/sn-A102260003/';

files = dir(fullfile(calibfolder, 'data.C.*__C__T1CALIB__MOD_*.RAW'));

data = dlmread(fullfile(calibfolder, 'zoom_focus.txt'));

[~, match_zoom] = min(abs(data(:,1) - model.zoom));
[~, match_focus] = min(abs(data(match_zoom,2) - model.focus));

matching_file = files(match_zoom(match_focus)).name;

raw = read_raw_calib(fullfile(calibfolder, matching_file), model.raw_size);

end

function raw = remove_hot( raw, hot )

figure, imshow(raw);
hot_px = hot > 0.99;
raw_avg = imfilter(raw, fspecial('average'));
raw(hot_px) = raw_avg(hot_px);
figure, imshow(raw);

end


function [ out ] = read_raw_calib( filename, imsize )

id = fopen(filename);
raw = fread(id, imsize, 'ubit12=>uint16', 0, 'b')';
fclose(id);

% convert 12 to 16 bit
raw = uint16((double(raw) ./ 2^12) * 2^16);

% demosaic
% raw = demosaic(raw, 'bggr');
out = im2double(raw);

% luminance channel only
% out = rgb2gray(out);

end