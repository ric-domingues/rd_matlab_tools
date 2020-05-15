function [INT,MAG]=ext_magnitude(T);

t=sprintf('%.14d',T);

k=find(t=='e');
MAG=str2num(t(k+1:end));

INT = str2num(t(1:k-1));





