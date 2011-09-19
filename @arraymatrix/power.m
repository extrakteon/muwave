function c = power(a,b)
% POWER returns a.^b of each matrix element

c = arraymatrix(a);
mtrx = a.mtrx;
mtrx = mtrx.^b;
c.mtrx = mtrx; 