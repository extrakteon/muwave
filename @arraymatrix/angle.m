function c = angle(a)
% ANGLE returns the angle of each matrix element

c = arraymatrix(a);
mtrx = a.mtrx;
mtrx = angle(mtrx);
c.mtrx = mtrx; 