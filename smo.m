	function out = smo(map);
% SMO(map) returns a map smoothed by a 1-2-1 smoother.
%         This is a version of m-file of
%         Lindstrom's SMO fortran subroutine.
%
%                           Sep-30-93    HSKim

[nrow,ncol] = size(map);
flag=1.0E+35;
out = ones(nrow,ncol)*flag;

nrm1 = nrow - 1;
ncm1 = ncol - 1;
 
for nr = 2:nrm1
  for nc = 2:ncm1
    out(nr,nc)=0.0625*(map(nr-1,nc-1)+map(nr-1,nc+1)+map(nr+1,nc+1)+map(nr+1,nc-1))+...
               0.125*(map(nr,nc+1)+map(nr,nc-1)+map(nr+1,nc)+map(nr-1,nc))+...
               0.25*map(nr,nc);
  end
end

for nc = 2:ncm1
  out(1,nc)=0.5*(0.25*(map(1,nc-1)+map(1,nc+1))+0.5*map(1,nc)+...
                 0.25*(map(2,nc-1)+map(2,nc+1))+0.5*map(2,nc));
  out(nrow,nc)=0.5*(0.25*(map(nrow,nc-1)+map(nrow,nc+1))+0.5*map(nrow,nc)+...
                    0.25*(map(nrm1,nc-1)+map(nrm1,nc+1))+0.5*map(nrm1,nc));
end

for nr = 2:nrm1
  out(nr,1)=0.5*(0.25*(map(nr-1,2)+map(nr+1,2))+0.5*map(nr,2)+...
                 0.25*(map(nr-1,1)+map(nr+1,1))+0.5*map(nr,1));
  out(nr,ncol)=0.5*(0.25*(map(nr-1,ncm1)+map(nr+1,ncm1))+0.5*map(nr,ncm1)+...
                    0.25*(map(nr-1,ncol)+map(nr+1,ncol))+0.5*map(nr,ncol));
end

out(1,1) = 0.5*map(1,1) + 0.25*(map(1,2) + map(2,1));
out(1,ncol) = 0.5*map(1,ncol) + 0.25*(map(1,ncm1) + map(2,ncol));
out(nrow,1) = 0.5*map(nrow,1) + 0.25*(map(nrm1,1) + map(nrow,2));
out(nrow,ncol)=0.5*map(nrow,ncol)+0.25*(map(nrow,ncm1)+map(nrm1,ncol));

