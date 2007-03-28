%
% ArrayMatrix
% class for handling arrays of matrices
%
% author: Kristoffer Andersson
%
%


% returns the square root of each matrix-element
function c = sqrt(a)

c = arraymatrix(a);
mtrx = a.mtrx;
mtrx = sqrt(mtrx);
c.mtrx = mtrx; 