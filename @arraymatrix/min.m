function c = min(a,b)
%MIN  returns the min element of each element
%
% $Header$
% $Author$
% $Date$
% $Revision$ 
% $Log$
% Revision 1.1  2004/05/28 07:01:34  koffer
% *** empty log message ***
%
%

a = arraymatrix(a);
b = arraymatrix(b);
% check so that the dimensions are equal
c = arraymatrix(a);
c.mtrx = min(a.mtrx,b.mtrx);
  