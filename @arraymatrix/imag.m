%
% ArrayMatrix
% class for handling arrays of matrices
%
% author: Kristoffer Andersson
%
%


% returns the imag of each matrix
function c = imag(a)

c = arraymatrix(a);
mtrx = a.mtrx;
mtrx = imag(mtrx);
c.mtrx = mtrx; 