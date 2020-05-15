function [PROFB,S,T,P]=depth_mono_incr(profb,vari,z_ref)

% 	This function make sure pressure and depth increase monotonically
%
%		- Also interpolates defined var to reference depth levels z_ref
%
%	require: box_withdata.m
%
%       usage: PROFB=keep_good_prof(profb,vari,flag_good,ID)
%
%	profb ------------------------------------------> box profiles	
%	vari = ------------------------------------------> Variables to eval (e.g stp)
%		p = press, s = salt, t = temperature
%	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if(exist('vari')==0)
	vari=[];
else
   vari=lower(vari);
end

      			[ num, l1, l2 ] = box_withdata( profb, 'temp' );
			for l = 1 : length( l1 )

				% convert pressure to depth
         			y = ones( [ size( profb( l1(l),l2(l) ).pres, 1 ) 1 ] )*profb( l1(l), l2(l) ).latitude;
         			profb( l1(l), l2(l) ).depth = pres2z( profb( l1(l),l2(l) ).pres ,y );

				% maximum profile depth, used to determine if the XBTs are "deep", T7 or DeepBlue
				max_depth = [];				
				% make sure pressure and depth increase monotonically
         			for m=1:length(profb(l1(l),l2(l)).time)

					ii = find(~isnan( profb( l1(l), l2(l) ).depth(:,m) ));
					max_depth(m) = profb( l1(l), l2(l) ).depth(ii(end),m);

            				ii=find(diff(profb(l1(l),l2(l)).pres(:,m))<=0);
					
            				if length(ii),
               					profb(l1(l),l2(l)).pres(ii+1,m)=NaN;
               					profb(l1(l),l2(l)).depth(ii+1,m)=NaN;
            				end

            				ii=find(~isnan(profb(l1(l),l2(l)).pres(:,m)));
            				jj=find(diff(profb(l1(l),l2(l)).pres(ii,m))<=0);
            				while length(jj)
               					profb(l1(l),l2(l)).pres(ii(jj+1),m)=NaN;
               					ii=find(~isnan(profb(l1(l),l2(l)).pres(:,m)));
               					jj=find(diff(profb(l1(l),l2(l)).pres(ii,m))<=0);
            				end

            				ii=find(isnan(profb(l1(l),l2(l)).pres(:,m)));
            				profb(l1(l),l2(l)).depth(ii,m)=NaN;					
										
					if(exist('z_ref') && ~isempty(find(vari=='p')))
						z=z_ref;

						ii=find(~isnan(profb(l1(l),l2(l)).pres(:,m)));
            					if length(ii)>1,
               						p(:,m)=interp1(profb(l1(l),l2(l)).depth(ii,m), ...
                      						profb(l1(l),l2(l)).pres(ii,m),z);
            					else
               						p(:,m)=NaN+z;
            					end
					end
					if(exist('z_ref') && ~isempty(find(vari=='t')))
            					ii=find(~isnan(profb(l1(l),l2(l)).temp(:,m)+ profb(l1(l),l2(l)).depth(:,m)));
            					if length(ii) > 1
               						t(:,m)=interp1(profb(l1(l),l2(l)).depth(ii,m), ...
								profb(l1(l),l2(l)).temp(ii,m),z);
            					else
               						t(:,m)=NaN+z;
            					end
					end
					if(exist('z_ref') && ~isempty(find(vari=='s')))
            					ii=find(~isnan(profb(l1(l),l2(l)).sal(:,m)+ ...
                    				profb(l1(l),l2(l)).depth(:,m)));

						if length(ii)>1,
							s(:,m)=interp1(profb(l1(l),l2(l)).depth(ii,m), ...
								profb(l1(l),l2(l)).sal(ii,m),z);
						else
							s(:,m)=NaN+z;
						end
					end
					
         			end % for m=1:length(profb(l1(l),l2(l)).time)
			end

	PROFB=profb;
	
	if(~isempty(find(vari,'s')))
		S=s;
	end
	if(~isempty(find(vari,'t')))
		T=t;
	end
	if(~isempty(find(vari,'p')))
		P=p;
	end