function [ im, model, im_raw ] = load_lfp( fname )

[im_raw,model] = read_lfp(fname);
im = preprocess(im_raw, model);