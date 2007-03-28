function ga = ga(a)
%GA   Returns the maximum available gain for two-port devices.

% $Header$
% $Author: fager $
% $Date: 2003-07-18 15:51:11 +0200 (Fri, 18 Jul 2003) $
% $Revision: 93 $ 
% $Log$
% Revision 1.2  2003/07/18 13:51:09  fager
% Matlab-standardized help and CVS-logging added.
%

switch nargin
case 1
    if get(a.Data,'ports') == 2
        s21 = abs(a.Data.S21);
        s12 = abs(a.Data.S12);
        k = k_fact(a);
        ga = abs(s21).*(k - sqrt(k.^2 - 1))./abs(s12);
    else
        error('MEASSP.GA: Argument must be a 2-port.');
    end
otherwise
    error('MEASSP.GA: Wrong number of arguments.');
end