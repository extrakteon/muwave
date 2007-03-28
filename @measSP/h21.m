function h21 = h21(a)
% Return the short-circuit gain of a two port
% 2002-01-09, Kristoffer Andersson
%             First version

switch nargin
case 1
    if get(a.Data,'ports') == 2
        h21 = -2*a.Data.S21./((1 - a.Data.S11).*(1 + a.Data.S22) + a.Data.S21.*a.Data.S21);
    else
        error('MEASSP.H21: Argument must be a 2-port.');
    end
otherwise
    error('MEASSP.H21: Wrong number of arguments.');
end