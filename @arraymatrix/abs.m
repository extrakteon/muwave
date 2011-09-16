function c = abs(a)
% ABS   Returns the absolute values of the arraymatrix elements.

c = arraymatrix(a);
mtrx = a.mtrx;
mtrx = abs(mtrx);
c.mtrx = mtrx; 
