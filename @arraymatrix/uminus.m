function c=uminus(a)
% UMINUS Overload operator unary -

c=arraymatrix(a);
mtrx = c.mtrx;
mtrx = -mtrx;
c.mtrx = mtrx;