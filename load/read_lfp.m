function [ out, model ] = read_lfp( image )

fprintf('loading %s...\n', image);

addpath('lib/jsonlab');

raw_file = sprintf('%s_imageRef0.raw',image);
metadata_file = sprintf('%s_metadataRef0.json',image);
alpha_file = sprintf('%s_alpha.txt',image);
calibdata_file = '../../data/sn-A102260003/data.C.3__C__T1CALIB__MLACALIBRATION.TXT';

% read metadata
meta = loadjson(metadata_file);
calib = loadjson(calibdata_file);

model.raw_size = [meta.image.height meta.image.width];
model.pixel_pitch = meta.devices.sensor.pixelPitch;
model.lens_pitch = meta.devices.mla.lensPitch;
model.rotation = meta.devices.mla.rotation;
model.scale = [meta.devices.mla.scaleFactor.x, meta.devices.mla.scaleFactor.y];
model.offset = [meta.devices.mla.sensorOffset.x, meta.devices.mla.sensorOffset.y];
model.shift = [model.offset(1) / model.pixel_pitch - 2, model.offset(2) / model.pixel_pitch];
model.zoom = meta.devices.lens.zoomStep;
model.focus = meta.devices.lens.focusStep;
model.fnumber = meta.devices.lens.fNumber;
model.focal_length = meta.devices.lens.focalLength;
model.z_offset = meta.devices.mla.sensorOffset.z;

model.lens_size = model.lens_pitch / model.pixel_pitch;

[~,ind_zoom] = min(abs(calib.zoomPosition - meta.devices.lens.zoomStep));
[~,ind_focus] = min(abs(calib.focusPosition(ind_zoom) - meta.devices.lens.focusStep));

model.origin = [calib.xDiskOriginPixels(ind_zoom,ind_focus) calib.yDiskOriginPixels(ind_zoom,ind_focus)];
model.x_step = [calib.xDiskStepPixelsX(ind_zoom,ind_focus) calib.xDiskStepPixelsY(ind_zoom,ind_focus)];
model.y_step = [calib.yDiskStepPixelsX(ind_zoom,ind_focus) calib.yDiskStepPixelsY(ind_zoom,ind_focus)];
model.pupil = calib.exitPupilDistanceMilli(ind_zoom,ind_focus);
model.basis_hex = [model.x_step; model.y_step]';

fid = fopen(alpha_file);
if fid > -1
	model.alpha = fscanf(fid, '%f');
	fclose(fid);
end

% model

% decode raw image
out = read_raw(raw_file, [meta.image.width, meta.image.height]);
if nargin < 2 && size(out,3) > 1
	out = rgb2gray(out);
end

end


function out = read_raw(raw_file, imsize)

id = fopen(raw_file, 'r');
raw = fread(id, imsize, 'uint16=>uint16')';
fclose(id);

raw = demosaic(raw, 'bggr');
out = double(raw) ./ 2^16;

end