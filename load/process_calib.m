addpath('jsonlab');

calibfolder = '../../data/sn-A102260003/';

files = dir(fullfile(calibfolder, 'data.C.*__C__T1CALIB__MOD_*.TXT'));

data = zeros(size(files,1),2);
for i = 1:size(files,1)
	fname = files(i).name;
	json = loadjson(fullfile(calibfolder, fname));
	z = json.master.picture.frameArray{1}.frame.metadata.devices.lens.zoomStep;
	f = json.master.picture.frameArray{1}.frame.metadata.devices.lens.focusStep;
	data(i,:) = [z f];
end

dlmwrite(fullfile(calibfolder, 'zoom_focus.txt'), data);