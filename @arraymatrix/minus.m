function c = minus(a,b)
% ARRAYMATRIX/MINUS Overload operator-
%
% $Header$
% $Author: koffer $
% $Date: 2005-10-11 10:32:23 +0200 (Tue, 11 Oct 2005) $
% $Revision: 298 $ 
% $Log$
% Revision 1.5  2005/10/11 08:32:23  koffer
% Introducing MEX-files for a faster implementation of arraymatrix.
%
% Revision 1.4  2004/10/27 18:24:36  koffer
% minus/plus and mtimes where so full of bugs that they have been rewwritten from srcatch. Local functions have been moved to /private
%
% Revision 1.3  2004/10/26 14:13:12  koffer
% Optimization. Now should run about 5 times faster.
%
%

THIS = 'arraymatrix:minus';

if isa(a,'double') 
    mtrx = amminus(a,b.mtrx);
elseif isa(b,'double')   
    mtrx = amminus(a.mtrx,b);
 else
    mtrx = amminus(a.mtrx,b.mtrx);
end
c = arraymatrix(mtrx);