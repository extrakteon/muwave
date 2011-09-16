function b=inv(a)
% INV Returns the matrix inverse of a

b=a;
% mtrx=a.mtrx;
if a.nx ~= a.ny
    error('ARRAYMATRIX.INV: Matrices must be square.');
else
    b.mtrx = aminv(a.mtrx);  
end