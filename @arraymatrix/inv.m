%
% ArrayMatrix
% class for handling arrays of matrices
%
% author: Kristoffer Andersson
%
%
% Method inv
function b=inv(a)

b=a;
% mtrx=a.mtrx;
if a.nx ~= a.ny
    error('ARRAYMATRIX.INV: Matrices must be square.');
else
    b.mtrx = aminv(a.mtrx);  
end