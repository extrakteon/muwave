%
% ArrayMatrix
% class for handling arrays of matrices
%
% author: Kristoffer Andersson
%
%


% returns the abs of each matrix
function c = abs(a)

c = arraymatrix(a);
mtrx = a.mtrx;
mtrx = abs(mtrx);
c.mtrx = mtrx; 