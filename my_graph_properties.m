function my_graph_properties(Xtick,Ytick)


if(exist('Xtick'))
	if Xtick
	set(gca,'xminortick','on')
	end
else
	set(gca,'xminortick','on')
end

if(exist('Ytick'))
	if Ytick
	set(gca,'yminortick','on')
	end
else
	set(gca,'yminortick','on')
end

set(gca,'linewidth',1)
set(gca,'fontsize',12)
%  set(gca,'fontname','URW Gothic L')
grid on