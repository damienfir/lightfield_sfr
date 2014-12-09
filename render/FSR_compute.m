function [ res ] = FSR_compute( im4d_fft, alpha )
%FSR_COMPUTE Returns refocused image
% By C. Marx & L. Baboulaz - EPFL Spring 2013

% res = [];
res_t(:,:,1) = FSR_slice(im4d_fft(:,:,:,:,1),alpha);
% res_t(:,:,2) = FSR_slice(im4d_fft(:,:,:,:,2),alpha);
% res_t(:,:,3) = FSR_slice(im4d_fft(:,:,:,:,3),alpha);

% Scale refocused image in [0,255]
res_t = res_t - min(res_t(:));
res = res_t / max(res_t(:));

end