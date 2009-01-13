% Overladed trace
function tr = trace(a)
%TRACE    Trace of matrix.
% $Header$
% $Author$
% $Date$
% $Revision$ 
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
