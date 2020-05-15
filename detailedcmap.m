function detailedcmap(cmapuse)

load(cmapuse)
NI=500;
[m,n] = size(cmap);
for j=1:3
	aux = cmap(:,j);
	aux2 = interp1([1:m],aux,linspace(1,m,NI));
	cmapOUT(:,j) = aux2;
end
colormap(cmapOUT)
