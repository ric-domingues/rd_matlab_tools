%Aluno :Marlos Goes             
%Instituto Oceanografico
%Universidade de Sao Paulo
%Sao Paulo - Brasil
%Ajuste de curvas
%Objetivos: Fazer o ajuste de uma curva qualquer
%pelo metodo de Gram-Schimidt

%Procedimento: novo=f(n);
%              func= (P. ex.) 'x.^2+1-x.^-1' 
%Tabela a:Distancia (X) Altura(Z)

%PARA RICARDO
%x(:,1) = sin([1:2:360]/(2*pi));
%x(:,2) = cos([1:2:360]/(2*pi));
%y = 3*x(1,:) + 1*x(2,:);
%[v,yfit,O]=algebra3(x,y,'1+x(:,1)+x(:,2)',1,1);

function [v,yfit,O]=algebra3(x,z,func,err,modo,doplot)
%output
%v - parameter values
%yfit - fitted series
%o - std error

%input
%x = Variavel Independente;
%z = Variavel Dependente;
%func = function to optimize
%err = standard deviation of novo

%[a]=matriz2(n);
%n e o lag, novo e a correlacao
%a1=[sign(cc(:,1)).*log(abs(cc(:,1))),sign(cc(:,2)).*(log(abs(cc(:,2))))];
%acha=find(isnan(a1(:,1)));
%a=[a(1:12,:);a(14:end,:)];

l = length(x);
nvar = size(x);%(x,2);
if nargin < 6, doplot = 1;end
if nargin < 5, modo = 'normal';end
if nargin < 4, err = 0;end
if length(err) == 1, err = err*ones(l,1);end

z = z(:);%novo(:); %x = n; 
if strcmp(modo,'logit')
 maxz = max(z);
 z = log(z+ceil(maxz));
end

whos
%a = [n,z];
%x = n;
func = [func,';'];                                          %add ;
vector = sort([findstr(func,'+') length(func)]);            %find terms
if min(vector~=1);vector(1:length(vector)+1)=[1 vector];
end
%vector
%matriz=[g1 g2 g3];
matriz = [];
func2 = 'f(x)= ';
for i = 1:length(vector)-1
    g = func(vector(i):vector(i+1)-1);
    func2 = [func2,g,'*v(',num2str(i),')'];
    if size(str2num(g))==1; 
        g = ['ones(l,1)*',g];
    end
    g
    matriz = [matriz eval([g,';'])];%[matriz eval([g,';'])];
end

c = matriz'*matriz;
acha = ~isnan(z);
 d = matriz(acha,:)'*z(acha);
[q,r] = lu(c);
%k=q*r-c;
%qi = 1\q;  %wrong
qi = q\eye(nvar(2)+1);
 w = qi*d;
 v = zeros(size(w));
 for i = length(w):-1:1
  v(i) = (w(i)-r(i,:)*v)/r(i,i);
 end
%Fit vector
yfit = matriz*v;

%Differences
E = sqrt(nansum([(z - yfit).^2, err.^2],2));
%O = sqrt(mean((z - yfit).^2));
O=c*v-d;



func3{1} = func2;
for i = 1:length(v)
    numero = num2str(v(i),'%3.3f');
    func3{i+1} = ['v(',num2str(i),')=',numero,'+/-',num2str(O(i))];
end
if doplot
    for i = 1:nvar(2)
        figure(i)
        plot(x(:,i),z,'.')
        hold on
        plot(x(:,i),v(1)+x(:,i)*v(i+1),'k')
        gtext(func3([1 i+1]))
%          save2eps(['param',num2str(i),'.eps'],i,300)
    end
    
    %BACK TO INITIAL VALUE
if strcmp(modo,'logit')
    z = exp(z)-maxz;
yfit = exp(yfit)-maxz;
E = sqrt(nansum([(z - yfit).^2, err.^2],2));
end

figure(nvar(2)+1)
 x2 = 1:length(yfit);
 %for i=1:nvar
%  h = errorbar(x2,yfit,E,'.');hold on
%   set(h,'color',[0.7 0.7 0.7]);
plot(x2,z,'r')%o')
  hold on
 h= plot(x2,yfit,'linewidth',1.5,'color',[0.4 0.4 0.4]);
  xlim([x2(1) x2(end)])
  xlabel('Time')
 %end
 %h = errorbar(x,yfit,O);
 gtext(func3)
%   save2eps('series_fit.eps',nvar(2)+1,300)

end
end
