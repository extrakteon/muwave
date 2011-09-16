function c = conj(a)
% CONJ returns the conjugate of each matrix element

c = arraymatrix(a);
mtrx = a.mtrx;
mtrx = conj(mtrx);
c.mtrx = mtrx; 