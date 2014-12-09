clearvars;

addpath('target','lib/export');

% circles = generate_deadleaves(500, 50000);
% save('data/deadleaves.mat','circles');
load('data/deadleaves.mat');

figure
ci = circles(:,1:10000);
plot_deadleaves(ci);

ti = get(gca, 'TightInset');
set(gca, 'Position', [ti(1) ti(2) 1-ti(3)-ti(1) 1-ti(4)-ti(2)]);

set(gca,'units','centimeters')
pos = get(gca,'Position');
ti = get(gca,'TightInset');

set(gcf, 'PaperUnits','centimeters');
set(gcf, 'PaperSize', [pos(3)+ti(1)+ti(3) pos(4)+ti(2)+ti(4)]);
set(gcf, 'PaperPositionMode', 'manual');
set(gcf, 'PaperPosition',[0 0 pos(3)+ti(1)+ti(3) pos(4)+ti(2)+ti(4)]);

print('fig.eps','-deps','-painters')

% im = export_fig('fig.pdf','-r100','-painters');

% close
% figure, imshow(abs(fftshift(fft2(im))),[0 1e4]);