function input2NC(time,lon,lat,grid1,outfile,RMODE);


if(RMODE==1)
	
	[lat_num,lon_num,time_num]=size(grid1);

  	ncid = netcdf.create(outfile,'NC_WRITE');
%  
%  	% Define the dimensions of the variable.

	lat_name = 'latitude';
  	lat_dimid = netcdf.defDim ( ncid, lat_name, lat_num );

  	lon_name = 'longitude';
  	lon_dimid = netcdf.defDim ( ncid, lon_name, lon_num );

  	rec_name = 'time';
  	rec_dimid = netcdf.defDim ( ncid, rec_name, netcdf.getConstant ( 'NC_UNLIMITED' ) );

	lat_varid = netcdf.defVar ( ncid, lat_name, 'double', lat_dimid );
  	lon_varid = netcdf.defVar ( ncid, lon_name, 'double', lon_dimid );
	time_varid = netcdf.defVar ( ncid,rec_name, 'double', rec_dimid );

	units = 'units';
  	lat_units = 'degrees north';
  	netcdf.putAtt ( ncid, lat_varid, units, lat_units );
  	lon_units = 'degrees east';
  	netcdf.putAtt ( ncid, lon_varid, units, lon_units );
	time_units = 'julian days (julian.m)';
  	netcdf.putAtt ( ncid, time_varid, units, time_units );

	dimids = [ lat_dimid, lon_dimid, rec_dimid ];

  	grid1_name = 'grid1';
  	grid1_varid = netcdf.defVar ( ncid, grid1_name, 'double', dimids );

       	netcdf.endDef ( ncid );

	% PUT THE DATA

	netcdf.putVar ( ncid, lat_varid, lat );
  	netcdf.putVar ( ncid, lon_varid, lon );
	netcdf.putVar ( ncid, time_varid,0,length(time),time );

  	count = [ lat_num, lon_num, time_num ];
  	start = [ 0, 0, 0 ];
	
	netcdf.putVar ( ncid, grid1_varid, start, count, grid1 );

	netcdf.sync(ncid);
	netcdf.close(ncid);
	
end

if(RMODE==2)
	
	[lat_num,lon_num,time_num]=size(grid1);

  	ncid = netcdf.open(outfile,'write');

	% PUT THE DATA


	grid1_varid = netcdf.inqVarID(ncid,'grid1');
	time_varid = netcdf.inqVarID(ncid,'time');

	time_ref = netcdf.getVar(ncid,time_varid);			
	netcdf.putVar ( ncid, time_varid,length(time_ref),length(time),time );

	count = [ lat_num, lon_num, time_num ];
  	start = [ 0, 0, length(time_ref) ];
	
	netcdf.putVar ( ncid, grid1_varid, start, count, grid1 );

	netcdf.sync(ncid);
	netcdf.close(ncid);

end






