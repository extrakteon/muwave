%
% ArrayMatrix
% class for handling arrays of matrices
%
% author: Kristoffer Andersson
%
%


% returns the identity matrix
function c = ident(a)
if a.nx ~= a.ny
    error('ARRAYMATRIX.INV: Matrix must be square.');
else
    c = arraymatrix(repmat(eye(a.nx),[1 1 a.m]));
end
