function grid_RD

hold on

XTICKS = get(gca,'xtick');
YTICKS = get(gca,'ytick');

XLIM=get(gca,'xlim');
YLIM=get(gca,'ylim');

for i=1:length(XTICKS)

	plot([XTICKS(i) XTICKS(i)],YLIM,':','linewidth',.5,'color',[.3 .3 .3]);
end

for i=1:length(YTICKS)

	plot(XLIM,[YTICKS(i) YTICKS(i)],':','linewidth',.5,'color',[.3 .3 .3]);
end