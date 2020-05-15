function [mm,dd,yyyy,JUL] = time_YY2jul(time_YY)
%  function time_GMT=time_jul2GMT(time_ref)
%  Transform dates into decimal years
mm=NaN;dd=NaN;yyyy=NaN;JUL=NaN;


yyyy = floor(time_YY./10000);
mm = floor(time_YY./100) - yyyy*100;
dd = time_YY - (yyyy*10000 + mm*100);

JUL = julian(yyyy,mm,dd,0);

%  [time_YY yyyy mm dd]
