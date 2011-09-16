function c = max(a,b)
% MAX  returns the max element of each element

a = arraymatrix(a);
b = arraymatrix(b);
% check so that the dimensions are equal
c = arraymatrix(a);
c.mtrx = max(a.mtrx,b.mtrx);
  