function Beta = sw_Bplane(lat);

	

DEG2RAD = pi/180;
OMEGA   = 7.292e-5;     %s-1   A.E.Gill p.597
Rad = 6371*1e3; %earths radius

Beta = 2*OMEGA*cos(lat*DEG2RAD)./Rad;