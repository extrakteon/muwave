function delta = delta(a)
% Return delta of a two port
% 2002-01-09, Kristoffer Andersson
%             First version

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