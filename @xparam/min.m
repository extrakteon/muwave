function c = min(a,b)
%MIN  returns the min element of each element
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

a = xparam(a);
b = xparam(b);
% check so that the dimensions are equal
if a==b
    c = xparam(a);
    c.data = min(a.data,b.data);
end