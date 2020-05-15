function apply_ALL_axes(varargin)

allAxes = get(gcf,'Children');

for i=1:length(allAxes)

	CMD = ['set(allAxes(',num2str(i),'),',cellstrcat(varargin),')'];
	eval(CMD)
end




%  
%  for ii=1:length(varargin);
%  			CMD=[CMD,',''',varargin{ii},''''];
%  		end
%  
%  	CMD = [CMD,');'];
%  	eval(CMD)
%  
