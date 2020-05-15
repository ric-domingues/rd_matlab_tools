function time_GMT=time_jul2GMT(time_ref)
%  function time_GMT=time_jul2GMT(time_ref)
%  Transform dates into decimal years

greg = gregorian(time_ref);
yyyy = greg(:,1);
mm = greg(:,2);
dd = greg(:,3);

HH = greg(:,4);
MIN = greg(:,5);
SEC = greg(:,6);


for i = 1:length(time_ref)
	time_GMT(i) =  yyyy(i) + ((mm(i)-1) + (dd(i)/31))/12;
end
