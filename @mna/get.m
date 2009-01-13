function out = get(x,param)
% GET  returns the param

% $Header$
% $Author$
% $Date$
% $Revision$ 
% $Log$
% Revision 1.2  2005/09/12 14:17:01  koffer
% *** empty log message ***
%
% Revision 1.1  2004/04/28 15:56:32  koffer
% Support for second order sensitivities
%
%

switch param
    case 'Y'
        out = x.Y;
    case 'Yc'
        out = x.Yc;
    case 'type'
        out = x.param_type;
end