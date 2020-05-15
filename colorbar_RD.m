function cb=colorbar_RD(tit,tp,DX,SWIT,TSIZE);

%  function cb=colorbar_RD(tit,tp,DX,SWIT,TSIZE);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  
%  	This program places a nice colorbar in a nice location
%  	
%		tit - colorbar title	
%  		tp = 1, vertical (default)
%  		tp = 2, horizontal
%  		DX - distance to the axis (default 0.06)
%  		SWIT - control cb title horizontal
%		Tsize - fontsize
%  	
%  		Ricardo Domingues, AOML/NOAA
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if(~exist('tp'))
	tp=1;
end

if(~exist('DX'))
	DX=0.06;
end

if(~exist('TSIZE'))
	TSIZE=12;
end

if(~exist('SWIT'))
	SWIT=0;
end


if(tp==1)
	POSGCA = get(gca,'position');
	cb=colorbar;
	CBPOS = get(cb,'position');

	POSCB2 = (POSGCA(2)+ (.15)*POSGCA(4));


	set(cb,'position',[CBPOS(1)+DX POSCB2 0.015 (.7)*POSGCA(4)],'fontsize',TSIZE)

	if(exist('tit'))
		set(cb,'YAxisLocation','right')
		ylabel(cb,['\bf ',tit],'fontsize',TSIZE)


	end
	set(gca,'position',POSGCA)
end


if(tp==2)
	POSGCA = get(gca,'position');
	cb=colorbar('horizontal');
	CBPOS = get(cb,'position');	
	set(cb,'position',[CBPOS(1)+CBPOS(3)*0.15 CBPOS(2)-DX CBPOS(3)*0.7 0.02])

	set(gca,'position',POSGCA,'fontsize',TSIZE)

	if(exist('tit'))
		xlabel(cb,['\bf ',tit],'fontsize',TSIZE)

	if SWIT,set(cb,'XAxisLocation','bottom'), end
	end

end


