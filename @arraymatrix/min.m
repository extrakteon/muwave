function c = min(a,b)
% MIN  returns the min element of each element

a = arraymatrix(a);
b = arraymatrix(b);
% check so that the dimensions are equal
c = arraymatrix(a);
c.mtrx = min(a.mtrx,b.mtrx);
  