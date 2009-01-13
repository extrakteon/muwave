function c = plus(a,b)
% ARRAYMATRIX/PLUS Overload operator+
%
% $Header$
% $Author$
% $Date$
% $Revision$ 
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

THIS = 'arraymatrix:plus';

if isa(a,'double') 
    mtrx = amplus(a,b.mtrx);
elseif isa(b,'double')   
    mtrx = amplus(a.mtrx,b);
 else
    mtrx = amplus(a.mtrx,b.mtrx);
end
c = arraymatrix(mtrx);