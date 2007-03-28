%
% ArrayMatrix
% class for handling arrays of matrices
%
% author: Kristoffer Andersson
%
%


% skips the selected row and column
function c = skip(a,index)
if length(index) ~= 2
    error('ARRAYMATRIX.SKIP: The index vector must have exactly two elements.');
elseif max(index) > a.n | min(index) < 1
    error('ARRAYMATRIX.SKIP: Index vector out of range.');
else
    mtrx = a.mtrx;
    mtrx(index(1),:,:)=[];
    mtrx(:,index(2),:)=[];
    c = arraymatrix(mtrx);
end
