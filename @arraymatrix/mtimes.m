function c = mtimes(a,b)
%MTIMES Overload operator * (matrix multiply)

% $Header$
% $Author$
% $Date$
% $Revision$ 
% $Log$
% Revision 1.10  2005/10/11 08:32:23  koffer
% Introducing MEX-files for a faster implementation of arraymatrix.
%
% Revision 1.9  2004/10/27 18:24:36  koffer
% minus/plus and mtimes where so full of bugs that they have been rewwritten from srcatch. Local functions have been moved to /private
%
% Revision 1.8  2003/11/17 07:47:02  kristoffer
% *** empty log message ***
%
% Revision 1.7  2003/08/25 14:42:36  fager
% Matrix multiplication now works both with rectangular matrices and scalars.
%
% Revision 1.6  2003/08/25 09:25:45  fager
% Multiplication with scalar implemented and verified.
%
% Revision 1.5  2003/08/25 09:12:52  fager
% no message
%
% Revision 1.4  2003/08/25 09:08:11  fager
% Removed necessity of the input arguments to be of same size (multiplication of rectangular matrices).
%

if isa(a,'double') 
    mtrx = ammul(a,b.mtrx);
elseif isa(b,'double')   
    mtrx = ammul(a.mtrx,b);
 else
    mtrx = ammul(a.mtrx,b.mtrx);
end
c = arraymatrix(mtrx);
