function b = abs(a)
%ABS  returns the absolute value of each element
%
% $Header$
% $Author$
% $Date$
% $Revision$ 
% $Log$
% Revision 1.1  2004/05/28 07:03:19  koffer
% *** empty log message ***
%
%

b = xparam(a);
b.data = abs(a.data);
