function c = sech(a)
% SECH returns sech(a) of each matrix element

c = arraymatrix(a);
mtrx = a.mtrx;
mtrx = sech(mtrx);
c.mtrx = mtrx; 