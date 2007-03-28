%
% ArrayMatrix
% class for handling arrays of matrices
%
% author: Kristoffer Andersson
%
%


% returns the determinant of each matrix
function c = det(a)

if a.nx == a.ny
    mtrx = a.mtrx;
    M = a.m;
    for i=1:M
        c(i,1) = det(mtrx(:,:,i));
    end    
else
    error('ARRAYMATRIX.DET: Matrices must be square.');
end