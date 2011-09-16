function c = imag(a)
% IMAG returns the imag of each matrix element

c = arraymatrix(a);
mtrx = a.mtrx;
mtrx = imag(mtrx);
c.mtrx = mtrx; 