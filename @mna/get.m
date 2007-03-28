function out = get(x,param)
% GET  returns the param

% $Header$
% $Author: koffer $
% $Date: 2004-04-28 17:56:51 +0200 (Wed, 28 Apr 2004) $
% $Revision: 190 $ 
% $Log$
% Revision 1.1  2004/04/28 15:56:32  koffer
% Support for second order sensitivities
%
%

switch param
    case 'Y'
        out = x.Y
end