%
% ArrayMatrix
% class for handling arrays of matrices
%
% author: Kristoffer Andersson
%
%


% returns the angle of each matrix
function c = angle(a)

c = arraymatrix(a);
mtrx = a.mtrx;
mtrx = angle(mtrx);
c.mtrx = mtrx; 