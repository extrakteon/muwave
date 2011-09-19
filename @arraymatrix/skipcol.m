function c = skipcol(a,index)
% SKIPCOL skips the selected columns
if max(index)>a.ny
    error('ARRAYMATRIX.SKIPCOL: Index vector out of range.');
else
    mtrx = a.mtrx;
    mtrx(:,index,:)=[];
    c = arraymatrix(mtrx);
end
