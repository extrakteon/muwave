function Yx = calc(x,val)
% CALC  Calculates the Y-matrix for a given symbolic MNA-matrix
%       if the parameter list is a cell-array the paramers are treated as
%       conversion-matrices

% $Header$
% $Author: kristoffer $
% $Date: 2003-10-07 13:32:03 +0200 (Tue, 07 Oct 2003) $
% $Revision: 150 $ 
% $Log$
% Revision 1.6  2003/10/07 11:32:03  kristoffer
% no message
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
argstr = inputname(1);
assignin('caller',argstr,x);

Yx = x.Yc;
