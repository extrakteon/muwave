function h21 = h21(a)
%H21    Returns the short-circuit gain of a two-port device.

% $Header$
% $Author: fager $
% $Date: 2003-07-18 15:51:11 +0200 (Fri, 18 Jul 2003) $
% $Revision: 93 $ 
% $Log$
% Revision 1.2  2003/07/18 13:51:10  fager
% Matlab-standardized help and CVS-logging added.
%

switch nargin
case 1
    if get(a.Data,'ports') == 2
        h21 = -2*a.Data.S21./((1 - a.Data.S11).*(1 + a.Data.S22) + a.Data.S21.*a.Data.S21);
    else
        error('MEASSP.H21: Argument must be a 2-port.');
    end
otherwise
    error('MEASSP.H21: Wrong number of arguments.');
end