function [yyyy,mm,dd,JUL] = filename2dates(file);
%  function [yyyy,mm,dd,JUL] = filename2dates(file);

yyyy = str2num(file(1:4));
mm = str2num(file(5:6));
dd = str2num(file(7:8));

JUL = julian(yyyy,mm,dd,0);
