function tr = trace(a)
% TRACE    Trace of matrix.

N = min(a.nx,a.ny);
mtrx = a.mtrx;
for k = 1:N
    diagonals(k,:) = mtrx(k,k,:);
end
tr = sum(diagonals);
