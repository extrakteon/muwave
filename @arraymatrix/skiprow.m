function c = skiprow(a,index)
% SKIPROW skips the selected rows
if max(index)>a.nx
    error('ARRAYMATRIX.SKIPROW: Index vector out of range.');
else
    mtrx = a.mtrx;
    mtrx(index,:,:)=[];
    c = arraymatrix(mtrx);
end
