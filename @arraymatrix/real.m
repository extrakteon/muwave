%
% ArrayMatrix
% class for handling arrays of matrices
%
% author: Kristoffer Andersson
%
%


% returns the real of each matrix
function c = real(a)

c = arraymatrix(a);
mtrx = a.mtrx;
mtrx = real(mtrx);
c.mtrx = mtrx; 