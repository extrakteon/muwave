function y = freq(x,fv)
%FREQ Returns the frequency range of a MNA object.

% $Header$
% $Author: kristoffer $
% $Date: 2003-11-13 00:21:38 +0100 (Thu, 13 Nov 2003) $
% $Revision: 167 $ 
% $Log$
% Revision 1.4  2003/11/12 23:21:38  kristoffer
% *** empty log message ***
%
% Revision 1.3  2003/08/25 09:06:28  fager
% no message
%
% Revision 1.2  2003/08/25 09:06:11  fager
% Added method such as freq(mna_obj) returns the specified frequency range.

switch nargin
    case 1,
        y = x.f;
    case 2,
        y = x;
        y.f = reshape(fv,length(fv),1);
    otherwise,
        error('Illegal number of input arguments'); 
end