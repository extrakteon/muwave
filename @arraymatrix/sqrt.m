function c = sqrt(a)
% SQRT returns the square root of each matrix-element

c = arraymatrix(a);
mtrx = a.mtrx;
mtrx = sqrt(mtrx);
c.mtrx = mtrx; 