function time_YYYYMMDD=time_jul2YY(time_ref)
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
	time_YYYYMMDD(i) =  yyyy(i)*1e4 + mm(i)*1e2 + dd(i)*1;
end
