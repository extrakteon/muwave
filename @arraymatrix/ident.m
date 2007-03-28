%
% ArrayMatrix
% class for handling arrays of matrices
%
% author: Kristoffer Andersson
%
%


% returns the identity matrix
function c = ident(a)
c = arraymatrix(repmat(eye(a.n),[1 1 a.m]));

