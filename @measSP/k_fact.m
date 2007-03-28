function k = k_fact(a)
%K_FACT Rollet stability factor, K, for two-port devices.
%   K = K_FACT(MSP) returns the Rollet stability factor, K.
%
%   See also: DELTA

%   (c) Kristoffer Andersson & Christian Fager, Chalmers University of Technology, Sweden

% $Header$
% $Author: fager $
% $Date: 2004-10-21 00:25:32 +0200 (Thu, 21 Oct 2004) $
% $Revision: 220 $ 
% $Log$
% Revision 1.5  2004/10/20 22:23:57  fager
% Help comments added
%

switch nargin
case 1
    if get(a.data,'ports') == 2
        s1221 = a.data.S12.*a.data.S21;
        s11 = a.data.S11;
        s22 = a.data.S22;
        d = s11.*s22 - s1221;
        k = (1 - abs(s11).^2 - abs(s22).^2 + abs(d).^2)./(2*abs(s1221));
    else
        error('MEASSP.K_FACT: Argument must be a 2-port.');
    end
otherwise
    error('MEASSP.K_FACT: Wrong number of arguments.');
end
