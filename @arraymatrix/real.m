function c = real(a)
% REAL returns the real of each matrix element

c = arraymatrix(a);
mtrx = a.mtrx;
mtrx = real(mtrx);
c.mtrx = mtrx; 