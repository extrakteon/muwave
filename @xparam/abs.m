function b = abs(a)
%ABS  returns the absolute value of each element
%
% $Header$
% $Author: koffer $
% $Date: 2004-05-28 09:03:19 +0200 (Fri, 28 May 2004) $
% $Revision: 201 $ 
% $Log$
% Revision 1.1  2004/05/28 07:03:19  koffer
% *** empty log message ***
%
%

b = xparam(a);
b.data = abs(a.data);
