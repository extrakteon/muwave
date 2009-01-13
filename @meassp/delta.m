function delta = delta(a)
%DELTA  Delta of S-parameters.
%   d = DELTA(M) returns the delta of the two-port S-parameters in M.
%
%   See also: K_FACT
%

%   (c) Kristoffer Andersson & Christian Fager, Chalmers University of Technology, Sweden

% $Header$
% $Author$
% $Date$
% $Revision$ 
% $Log$
% Revision 1.7  2005/04/27 21:33:19  fager
% * Changed from measSP to meassp.
%
% Revision 1.6  2004/10/20 22:17:59  fager
% Help comments added
%
%

switch nargin
case 1
    if get(a.data,'ports') == 2
        delta = a.data.S11.*a.data.S22 - a.data.S12.*a.data.S21;
    else
        error('MEASSP.DELTA: Argument must be a 2-port.');
    end
otherwise
    error('MEASSP.DELTA: Wrong number of arguments.');
end