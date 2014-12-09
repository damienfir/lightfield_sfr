from matplotlib.pyplot import *
from numpy import *

folder = '../../../doc/report/img/plots/%s';


c = 'SteelBlue'
lw = 2


def sfr50(name):
	data = loadtxt('../data/plot/sfr50_'+name, delimiter=',')
	
	figure()
	plot(data[0,:],data[1,:], c='MidnightBlue', lw=lw, label='50% SFR')
	fill_between(data[0,:], data[1,:]+data[3,:], data[1,:]-data[3,:], color='MidnightBlue', alpha=0.2)
	plot(data[0,:],data[2,:], c='Green', lw=lw, label='10% SFR')
	fill_between(data[0,:], data[2,:]+data[4,:], data[2,:]-data[4,:], color='Green', alpha=0.2)

	xlabel('image row')
	ylabel('cycles/px')
	legend(loc='lower right')

	remove_topright()

	gca().set_aspect(3.5e2)
	savefig(folder % name+'.pdf', bbox_inches='tight')


def clusters(name):
	data = loadtxt('../data/plot/'+name, delimiter=',')

	figure()
	scatter(data[0,:], data[1,:], c='b', s=80)
	scatter(data[2,:], data[3,:], c='r', s=80)

	xlabel(r'$\sigma$', size=30)
	ylabel(r'$\epsilon$', size=30)

	remove_topright()

	savefig(folder % name+'.pdf', bbox_inches='tight')


def sfr_ml():
	data = loadtxt('../data/plot/sfr_ml', delimiter=',')

	figure()
	plot(data[0,:], data[1,:], c='FireBrick', lw=lw)
	title('SFR at focal point')
	ylabel('SFR')
	xlabel('cycles/px')
	xlim([0, 0.55])
	axvline(0.5, ymin=0, ymax=0.5, c='DarkSlateGray', ls='--', lw=2)
	text(0.475, -0.18, 'Nyquist')

	remove_topright()

	gca().set_aspect(0.2)
	savefig(folder % 'sfr_ml.pdf', bbox_inches='tight')


def sfr_ul_ml():
	data_ml = loadtxt('../data/plot/sfr_ml', delimiter=',')
	data_ul = loadtxt('../data/plot/sfr_ul', delimiter=',')

	figure()
	plot(data_ml[0,:], data_ml[1,:], c='FireBrick', lw=lw, label='At focal point')
	plot(data_ul[0,:], data_ul[1,:], c='SteelBlue', lw=lw, label='Behind focal point')
	plot(data_ul[0,:], data_ul[2,:], c='SeaGreen', lw=lw, label='In front of focal point')
	title('SFR at three different depths')
	ylabel('SFR')
	xlabel('cycles/px')
	xlim([0, 0.55])
	axvline(0.5, ymin=0, ymax=0.5, c='DarkSlateGray', ls='--', lw=2)
	text(0.475, -0.18, 'Nyquist')
	legend(frameon=False)

	remove_topright()

	gca().set_aspect(0.2)
	savefig(folder % 'sfr_ul_ml.pdf', bbox_inches='tight')


def n_uimages(image):
	data = loadtxt('../data/plot/n_uimages_'+image, delimiter=',')

	figure()
	plot(data[0,:], data[1,:], c='MidnightBlue', lw=lw)

	xlabel('image row')
	ylabel('# of valid microimages')
	ylim(0, nanmax(data[1,:]+5))

	remove_topright()

	gca().set_aspect(3)
	savefig(folder % 'n_uimages'+image+'.pdf', bbox_inches='tight')
	show()


def remove_topright():
	ax = gca()
	ax.get_xaxis().tick_bottom()
	ax.get_yaxis().tick_left()
	ax.spines["top"].set_visible(False)
	ax.spines["right"].set_visible(False)

