function k = k_fact(a)
%K_FACT Rollet stability factor, K, for two-port devices.
%   K = K_FACT(MSP) returns the Rollet stability factor, K.
%
%   See also: DELTA

%   (c) Kristoffer Andersson & Christian Fager, Chalmers University of Technology, Sweden

% $Header$
% $Author: fager $
% $Date: 2005-04-27 23:44:52 +0200 (Wed, 27 Apr 2005) $
% $Revision: 261 $ 
% $Log$
% Revision 1.6  2005/04/27 21:37:12  fager
% * Changed from measSP to meassp.
%
% Revision 1.5  2004/10/20 22:23:57  fager
% Help comments added
%

switch nargin
case 1
    if a.ports == 2
        s1221 = a.S12.*a.S21;
        s11 = a.S11;
        s22 = a.S22;
        d = s11.*s22 - s1221;
        k = (1 - abs(s11).^2 - abs(s22).^2 + abs(d).^2)./(2*abs(s1221));
    else
        error('MEASSP.K_FACT: Argument must be a 2-port.');
    end
otherwise
    error('MEASSP.K_FACT: Wrong number of arguments.');
end
