function [LSF,out] = get_uimage_lsf( uimage, angle )

out = 0;
ESF = 0;

if angle > 45
	angle = 90 - angle;
	uimage = uimage';
end

[H,W] = size(uimage);
factor = 4;

[X,Y] = meshgrid(-W*2:1/factor:W*2, 0:H-1);
slope = tan(angle*pi/180);

Ys = Y(:) + 1;
Xs = X(:) - slope * (Ys - 1) + 1;

rectified = interp2(uimage, Xs, Ys);
rectified = reshape(rectified, size(X));

ESF = nanmean(rectified, 1);

valid = find(~isnan(ESF));
left = valid(1);
right = valid(end);
ESF(1:left) = ESF(left);
ESF(right:end) = ESF(right);

LSF = abs(conv(ESF, [-0.5 0 0.5], 'same'));
LSF([1 end]) = 0;
LSF = conv(LSF, ones(1,4)/4, 'same');
LSF = LSF / sum(LSF);

x = 1:numel(LSF);
[sigma,mu] = gaussfit(x, LSF);

mu_normalized = (mu - valid(1)) / (valid(end) - valid(1));
LSF_fit = (1/(sqrt(2*pi)*sigma)) * exp(-0.5*((x-mu)/sigma).^2);
fit_score = sqrt(sum((LSF_fit - LSF).^2));

out = [sigma mu_normalized fit_score];
subplot 131
imshow(uimage)
subplot 132
imshow(rectified)
subplot 133
plot(x,LSF,'r',x,LSF_fit,'b');
title(sprintf('sigma = %f, fit = %f', sigma, fit_score));
xlim([valid(1) valid(end)])
ylim([0 1])
pause
