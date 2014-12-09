function [ lf ] = extract_lf( im, model )

fprintf('extracting light field...\n');

[xyuv, hex_grid] = lf_coordinates(model);
uimages = extract_uimages(im, xyuv);
lf = hex2rec_lf(uimages, hex_grid);