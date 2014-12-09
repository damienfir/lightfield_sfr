function [ res ] = FSR_preprocess( im4d )
%FSR_PREPROCESS Returns FFT of 4D lightfield image
% By C. Marx & L. Baboulaz - EPFL Spring 2013

res(:,:,:,:,1) = fftshift(fftn(im4d(:,:,:,:,1)));
% res(:,:,:,:,2) = fftshift(fftn(im4d(:,:,:,:,2)));
% res(:,:,:,:,3) = fftshift(fftn(im4d(:,:,:,:,3)));

end