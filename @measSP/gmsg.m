function gmsg = gmsg(a)
%GMSG   Returns the maximum stable gain for two-port devices.

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
        s21 = abs(a.Data.S21);
        s12 = abs(a.Data.S12);
        gmsg = abs(s21)./abs(s12);
    else
        error('MEASSP.GMSG: Argument must be a 2-port.');
    end
otherwise
    error('MEASSP.GMSG: Wrong number of arguments.');
end