%
% ArrayMatrix
% class for handling arrays of matrices
%
% author: Kristoffer Andersson
%
%


% Overladed ctranspose *
function c = ctranspose(a)

M = a.m;
mtrx = zeros(a.ny,a.nx,a.m);
mtrx_a = a.mtrx;
for i = 1:M
    mtrx(:,:,i) = mtrx_a(:,:,i)';
end
c = arraymatrix(mtrx);