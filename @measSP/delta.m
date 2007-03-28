function delta = delta(a)
%DELTA  Delta of S-parameters.
%   d=delta(M) returns the delta of the two-port S-parameters in M.

% $Header$
% $Author: fager $
% $Date: 2003-07-17 10:35:15 +0200 (Thu, 17 Jul 2003) $
% $Revision: 70 $ 
% $Log$
% Revision 1.3  2003/07/17 08:35:15  fager
% no message
%
% Revision 1.2  2003/07/17 08:34:30  fager
% Matlab documentation and CVS logging format added.
%

switch nargin
case 1
    if get(a.Data,'ports') == 2
        delta = abs(a.Data.S11.*a.Data.S22 - a.Data.S12.*a.Data.S21);
    else
        error('MEASSP.DELTA: Argument must be a 2-port.');
    end
otherwise
    error('MEASSP.DELTA: Wrong number of arguments.');
end