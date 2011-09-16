function [Lam,Uam] = lu(a)
% LU returns the lu-decomposition of each matrix (in the array)

A = a.mtrx;
for k = 1:length(a)
    [L(:,:,k),U(:,:,k)] = lu(A(:,:,k));
end
Lam = arraymatrix(L);
Uam = arraymatrix(U);