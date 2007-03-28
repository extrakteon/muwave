function gt = gt(a)
%GT Returns the transducer gain for two-port devices.

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
        gp = s21.*s21;
    else
        error('MEASSP.GT: Argument must be a 2-port.');
    end
otherwise
    error('MEASSP.GT: Wrong number of arguments.');
end