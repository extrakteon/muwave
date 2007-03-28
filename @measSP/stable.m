function stable = stable(a)
%STABLE Returns 1 if the two-port is stable.

% $Header$
% $Author: koffer $
% $Date: 2004-05-11 19:56:17 +0200 (Tue, 11 May 2004) $
% $Revision: 199 $ 
% $Log$
% Revision 1.2  2004/05/11 17:56:17  koffer
% Fixed typo
%
% Revision 1.1  2004/03/10 09:39:08  koffer
% Added function for determining stability of 2-ports.
%
%

switch nargin
case 1
    if get(a.data,'ports') == 2
        k = k_fact(a);
        d = delta(a);
        stable = (k > 1) & (abs(d)<1);
    else
        error('MEASSP.STABLE: Argument must be a 2-port.');
    end
otherwise
    error('MEASSP.STABLE: Wrong number of arguments.');
end