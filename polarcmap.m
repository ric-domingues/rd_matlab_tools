function polarcmap(CAXIS,lin)


    c=CAXIS;
    cmap=[c(1):diff(c)/100:c(2)];
    zpos=round(interp1(cmap,[1:101],0));
    if lin==1;
      RGB=[zeros(1,10) linspace(0,1,zpos-10) ones(1,86-zpos) linspace(1,.7,15); linspace(0.15,1,zpos) linspace(1,0.05,101-zpos); linspace(.6,1,15) ones(1,zpos-15) linspace(1,0,91-zpos) zeros(1,10)]';
      else
      RGB=[zeros(1,10) 1-linspace(1,0,zpos-10).^2 ones(1,91-zpos) linspace(1,.7,10); 1-linspace(.8,0,zpos).^2 1-linspace(0,1,101-zpos).^2; linspace(.6,1,10) ones(1,zpos-10) 1-linspace(0,1,91-zpos).^2 zeros(1,10)]';
    end
    colormap(RGB);
    caxis(CAXIS)

