%
% ArrayMatrix
% class for handling arrays of matrices
%
% author: Kristoffer Andersson
%
%


% returns the conjugate of each matrix
function c = conj(a)

c = arraymatrix(a);
mtrx = a.mtrx;
mtrx = conj(mtrx);
c.mtrx = mtrx; 