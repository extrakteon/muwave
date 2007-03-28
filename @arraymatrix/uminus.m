%
% ArrayMatrix
% class for handling arrays of matrices
%
% author: Kristoffer Andersson
%
%

% Overload operator unary -
function c=uminus(a)

c=arraymatrix(a);
mtrx = c.mtrx;
mtrx = -mtrx;
c.mtrx = mtrx;