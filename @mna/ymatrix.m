function Yx = ymatrix(x,val)
% CALC  Calculates the Y-matrix for a given symbolic MNA-matrix
%       if the parameter list is a cell-array the paramers are treated as
%       conversion-matrices

% $Header$
% $Author$
% $Date$
% $Revision$ 
% $Log$
% Revision 1.1  2004/04/28 15:56:51  koffer
% Support for second order sensitivities
%
% Revision 1.5  2003/10/06 07:11:45  kristoffer
% no message
%
% Revision 1.4  2003/10/06 06:47:14  kristoffer
% no message
%

if nargin == 2
    xval = val;
else
    xval = x.val;
end

x = recalc(x,xval);

Yx = x.Yc;
