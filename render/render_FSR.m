function [ rendered ] = render_FSR( lf, alpha )

addpath('render');

fprintf('Fourier slice rendering...\n');

fsr = FSR_preprocess(im2uint16(lf));
rendered = FSR_compute(fsr, alpha);