function c = log(a)
% LOG returns log(a) of each matrix element

c = arraymatrix(a);
mtrx = a.mtrx;
mtrx = log(mtrx);
c.mtrx = mtrx; 