[X,Y] = meshgrid(-20:20, -5:5);
XY = [X(:) Y(:)]';

f = 2;
T = [1 -f; 0 1];
L = [1 0; 1/f 1];

XY1 = T * XY;
XY2 = L * XY1;
XY3 = T * XY2;

figure, scatter(XY(1,:), XY(2,:));
figure, scatter(XY1(1,:), XY1(2,:));
figure, scatter(XY2(1,:), XY2(2,:));
figure, scatter(XY3(1,:), XY3(2,:));