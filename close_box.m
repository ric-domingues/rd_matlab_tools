function close_box

YLIME = get(gca,'ylim');
XLIME = get(gca,'xlim');


hold on

plot(XLIME,[YLIME(2) YLIME(2)],'k')