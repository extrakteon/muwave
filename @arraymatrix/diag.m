function c = diag(a)
% DIAG returns diag(a), where a is an arraymatrix column- or row-vector

SIZA = size(a);
if not(SIZA(1)==1 || SIZA(2)==1)
   error('ARRAYMATRIX/DIAG: Argument must be a column- or row-vector.'); 
end

if SIZA(1)==1
    a = a';
end

N =  max(SIZA(1),SIZA(2));
mtrx = zeros([N N SIZA(3)]);
for k = 1:N
    mtrx(k,k,:) = a.mtrx(k,1,:);
end

c = arraymatrix(mtrx);