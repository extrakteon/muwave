function c = tanh(a)
% TANH returns tanh(a) of each matrix element

c = arraymatrix(a);
mtrx = a.mtrx;
mtrx = tanh(mtrx);
c.mtrx = mtrx; 