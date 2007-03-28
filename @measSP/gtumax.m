function gtu = gtumax(a)
%GTUMAX Returns the maximum unilateral transducer gain for two-port devices.

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
        s11 = abs(a.Data.S11);
        s22 = abs(a.Data.S22);
        gtu = s21.*s21./((1-s11.*s11).*(1-s22.*s22));
    else
        error('MEASSP.GTUMAX: Argument must be a 2-port.');
    end
otherwise
    error('MEASSP.GTUMAX: Wrong number of arguments.');
end