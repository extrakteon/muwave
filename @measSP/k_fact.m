function k = k_fact(a)
%K_FACT Returns the Rollet stability factor, K, for two-port devices.

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
        s1221 = a.Data.S12.*a.Data.S21;
        s11 = a.Data.S11;
        s22 = a.Data.S22;
        k = (1 + abs(s11.*s22 - s1221).^2 - abs(s11).^2 - abs(s22).^2)./(2*abs(s1221));
    else
        error('MEASSP.K_FACT: Argument must be a 2-port.');
    end
otherwise
    error('MEASSP.K_FACT: Wrong number of arguments.');
end