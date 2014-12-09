function [ PSD_2D, freq_x, freq_u ] = sfr_2d( PSF )

PSD_2D = fftshift(abs(fft2(PSF)));

[nx,nu] = size(PSD_2D);
q_x = -floor(nx/2):floor(nx/2);
q_u = -floor(nu/2):floor(nu/2);

% frequencies
factor = 4;
T_x = 14e-3 * factor;
T_u = (4e-3/25e-3) * factor; % in mm
freq_x = q_x/(nx*T_x);
freq_u = q_u/(nu*T_u);

nyquist_x = 0.5 * T_x
nyquist_u = 0.5 * T_u

zero_x = find(freq_x == 0);
zero_u = find(freq_u == 0);
freq_x = freq_x(zero_x:end);
freq_u = freq_u(zero_u:end);
PSD_2D = PSD_2D(zero_x:end, zero_u:end);
% [max_x, max_u] = find(PSD_2D < 0.05);
% PSD_2D = PSD_2D(1:max_x(1), 1:max_u(1));
% freq_x = freq_x(1:max_x(1));
% freq_u = freq_u(1:max_u(1));

[X,U] = ndgrid(freq_x, freq_u);
surf(X, U, PSD_2D);
xlabel('spatial')
ylabel('angular')
zlabel('SFR')