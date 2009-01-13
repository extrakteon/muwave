function [x,Yx] = calc(x,val)
% CALC  Calculates the Y-matrix for a given symbolic MNA-matrix
%       if the parameter list is a cell-array the paramers are treated as
%       conversion-matrices
% $Header$
% $Author$
% $Date$

% $Log$
% Revision 1.8  2005/09/12 14:19:11  koffer
% *** empty log message ***
%

if nargin == 2
    xval = val;
else
    xval = x.val;
end

x = recalc(x,xval);
Yx = x.Yc;
if nargout == 1
    x = Yx;
end
