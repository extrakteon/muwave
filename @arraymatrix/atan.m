function c = atan(a)
% DIAG returns atan(a) for each matrix element

c = arraymatrix(a);
mtrx = a.mtrx;
mtrx = atan(mtrx);
c.mtrx = mtrx; 