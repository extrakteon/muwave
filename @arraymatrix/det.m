function c = det(a)
% DET returns the determinant of each matrix

if a.nx == a.ny
    mtrx = a.mtrx;
    M = a.m;
    for i=1:M
        c(i,1) = det(mtrx(:,:,i));
    end    
else
    error('ARRAYMATRIX.DET: Matrices must be square.');
end