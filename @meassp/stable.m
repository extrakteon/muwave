function stable = stable(a)
%STABLE Returns 1 if the two-port is stable.

% $Header$
% $Author$
% $Date$
% $Revision$ 
% $Log$
% Revision 1.3  2005/04/27 21:41:32  fager
% * Changed from measSP to meassp.
%
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