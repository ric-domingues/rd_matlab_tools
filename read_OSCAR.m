function [latitude longitude time date depth mask u v uf vf]=read_OSCAR(fnam)

%-----------------VERY IMPORTANT READ BEFORE PROCEDING------------------
%OSCAR data is in NetCDF format so you will need the mexnc toolbox, which
%can be dowloaded from http://mexcdf.sourceforge.net/.  You will need to
%add a path to the directory where the mexnc toolbox is located, just
%change line 60 to where the directory is.
% 


% FILENAME: read_OSCAR.m
%
% USAGE: To run this program, use the following command: 
%
% 	MATLAB>> [latitude longitude time date depth mask u v uf vf]=read_OSCAR(fnam)
%
%	where: 	fnam = INPUT filename including path
%		latitude = OUTPUT latitude 140 elements long
%       longitude = OUTPUT longitude 360 elements long
%       time = OUTPUT time 72 elements long
%       date = OUTPUT date 72 elements long
%       depth = OUTPUT depth 1 element long
%       mask = OUTPUT mask as a matrix [360x140]
%       u = OUTPUT u as a 4-D matrix [360x140x1x72], that corresponds to
%       longitude, latitude, place holder, and time
%       v = OUTPUT v as a 4-D matrix [360x140x1x72]
%       uf = OUTPUT uf as a 4-D matrix [360x140x1x72]
%       vf = OUTPUT vf as a 4-D matrix [360x140x1x72]
% 
% DESCRIPTION: This file contains one (1) MATLAB program to read the OSCAR
% data.  
%
% NOTES:
%
%	1.This read software was created using Matlab version 7.4.0.287 and mexnc 2.0.29. 
%	  If other versions of Matlab or mexnc are used, errors may occur due to 
%	  changes to the Matlab or mexnc commands. 
%	2.NetCDF is written as row major and Matlab is column major, therefore 
%     the columns are rows are switched than what is usually used in Matlab.
%     Please adjust accrodingly by transposing matrices or switching
%     indicies for rows and columns.
%	3. Refer to the comments after each mexcdf('get_var statement to find 
%      out the units for each variable.
%	4. Please email all comments and questions concerning these routines 
%	   to podaac@podaac.jpl.nasa.gov. 
%
% 18 August 2008: J.K. Hausman
%
% Revisions: 
%	None since the publication of the original code.
% 
%
%======================================================================
% Copyright (c) 2008, California Institute of Technology
%======================================================================



addpath ../../mexnc
%addpath /your mexnc directory        %change '/your mexnc directory' to the directory with mexnc if you
                                     %are already in the same directory as the mexnc then comment instead   

%open file
[ncid status]=mexcdf('open',fnam,nc_nowrite_mode);

%get ids of the variables
[latid status]=mexcdf('inq_varid',ncid,'latitude');
[lonid status]=mexcdf('inq_varid',ncid,'longitude');
[timeid status]=mexcdf('inq_varid',ncid,'time');
[dateid status]=mexcdf('inq_varid',ncid,'date');
[depthid status]=mexcdf('inq_varid',ncid,'depth');
[maskid status]=mexcdf('inq_varid',ncid,'mask');
[uid status]=mexcdf('inq_varid',ncid,'u');
[vid status]=mexcdf('inq_varid',ncid,'v');
[ufid status]=mexcdf('inq_varid',ncid,'uf');
[vfid status]=mexcdf('inq_varid',ncid,'vf');

%get variables
[latitude status]=mexcdf('get_var_float',ncid,latid);   %latitude in degrees
[longitude status]=mexcdf('get_var_float',ncid,lonid);  %longitude in degrees
[time status]=mexcdf('get_var_short',ncid,timeid);      %time in days since Oct. 5, 1992 00:00:00
[date status]=mexcdf('get_var_int',ncid,dateid);       %date as a character string
[depth status]=mexcdf('get_var_float',ncid,depthid);    %depth in meters
[mask status]=mexcdf('get_var_short',ncid,maskid);      %mask
[u status]=mexcdf('get_var_float',ncid,uid);            %u, zonal velocity in m/s
[v status]=mexcdf('get_var_float',ncid,vid);            %v, meridional velocity in m/s
[uf status]=mexcdf('get_var_float',ncid,ufid);          %uf, filtered zonal velocity in m/s
[vf status]=mexcdf('get_var_float',ncid,vfid);          %vf, filtered meridional velocity in m/s

status=mexcdf('close',ncid);

%citation information
% figurecitation = figure('XVisual',...
%     '0x22 (TrueColor, depth 24, RGB mask 0xff0000 0xff00 0x00ff)',...
%     'Name','Citation');
% annotation(figurecitation,'textbox',...
%     'String',{'If you use OSCAR data in publications, please include the following','citation:','','The OSCAR data were obtained from JPL Physical Oceanography','DAAC and developed by ESR.','','Also, ESR would appreciate receiving a preprint and/or reprint', 'of publications utilizing these data for inclusion in the OSCAR','bibliography. These publications should be sent to:','OSCAR Project Office','Earth and Space Research','2101 Fourth Avenue, Suite 1310','Seattle WA 98121'},...
%     'FontSize',14,...
%     'FontName','Arial',...
%     'FitHeightToText','off',...
%     'EdgeColor',[0 1 1],...
%     'LineWidth',4,...
%     'BackgroundColor',[1 1 1],...
%     'Position',[0.07488 0.1887 0.8429 0.74]);
% shg

