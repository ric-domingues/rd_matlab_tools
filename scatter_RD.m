function m_scatter_RD(lon,lat,int,cmap)

load scatter_RD_cmap
s
int0=int;

int = int-nanmean(int);
int = int-nanmin(int);

int = int./nanmax(int)+0.01;

int_cor = (linspace(nanmin(int0),nanmax(int0),length(cmap)));

for i=1:length(lon);

	IND_COR=find(int_cor>=int0(i));
	IND_COR = IND_COR(1);

	m_plot(lon(i),lat(i),'ko','markerfacecolor',cmap(IND_COR,:),'markersize',3+5*int(i));

end

RNG = nanmax(int0)-nanmin(int0);

%defining categories
NCATE = 3;
int_ref = round(linspace(nanmin(int0)+RNG*.25,nanmax(int0)-RNG*.25,NCATE));
int_ref2 = round(linspace(nanmin(int0)+RNG*.13,nanmax(int0)-RNG*.13,NCATE+1));
int_aux = linspace(0.13,.87,NCATE+1);
IND_COR = round(interp1(int_cor,1:length(cmap),int_ref2))

h1=plot(1000,1000,'ko','markerfacecolor',cmap(IND_COR(1),:),'markersize',3+6*int_aux(1));
h2=plot(1000,1000,'ko','markerfacecolor',cmap(IND_COR(2),:),'markersize',3+6*int_aux(2));
h3=plot(1000,1000,'ko','markerfacecolor',cmap(IND_COR(3),:),'markersize',3+6*int_aux(3));
h4=plot(1000,1000,'ko','markerfacecolor',cmap(IND_COR(4),:),'markersize',3+6*int_aux(4));

legend([h1 h2 h3 h4],[sprintf('<%03g [',int_ref(1)),UNIT,']'],[sprintf('%03g-%03g [',int_ref(1),int_ref(2)),UNIT,']'],...
[sprintf('%03g-%03g [',int_ref(2),int_ref(3)),UNIT,']'],[sprintf('>%03g [',int_ref(3)),UNIT,']'])




