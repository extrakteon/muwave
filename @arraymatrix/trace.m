% Overladed trace
function tr = trace(a)
%TRACE    Trace of matrix.
% $Header$
% $Author: koffer $
% $Date: 2005-07-06 12:28:22 +0200 (Wed, 06 Jul 2005) $
% $Revision: 293 $ 
% $Log$
% Revision 1.1  2005/07/06 10:27:56  koffer
% *** empty log message ***
%
%

N = min(a.nx,a.ny);
mtrx = a.mtrx;
for k = 1:N
    diagonals(k,:) = mtrx(k,k,:);
end
tr = sum(diagonals);
