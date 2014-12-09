s = [sqrt(2)*3280 3280]
s = int16(s);

width = 40;
line = ones(s(1), width/2);
linepair = [line 1-line];

lines = repmat(linepair, 1, s(2)/(width));

imshow(lines,[])
imwrite(lines, 'lines.tif')