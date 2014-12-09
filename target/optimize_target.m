% units: meter

D = 14e-6;		% micro lens diameter
f = 6.4e-3;		% mais lens focal length
b = f;			% mla z-offset
bp = 25e-6;		% sensor z-offset

a = 20;			% focus distance
w = 2e-3;		% target line width
x = 0.05;			% target distance


w0 = (D * b) / (2 * bp);
w_opt = ((a - x) / a) * w0
x_opt = a * (1 - w/w0)