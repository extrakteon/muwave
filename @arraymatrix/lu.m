function [Lam,Uam] = lu(a)
% LU returns the lu-decomposition of each matrix (in the array)
%

% $Header$
% $Author: kristoffer $
% $Date: 2003-11-17 08:49:10 +0100 (Mon, 17 Nov 2003) $
% $Revision: 169 $ 
% $Log$
% Revision 1.1  2003/11/17 07:47:02  kristoffer
% *** empty log message ***
%

A = a.mtrx;
for k = 1:length(a)
    [L(:,:,k),U(:,:,k)] = lu(A(:,:,k));
end
Lam = arraymatrix(L);
Uam = arraymatrix(U);