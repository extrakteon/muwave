function gp = gp(a)
% Return the power gain of a two port
% 2002-01-09, Kristoffer Andersson
%             First version

switch nargin
case 1
    if get(a.Data,'ports') == 2
        s21 = abs(a.Data.S21);
        s11 = abs(a.Data.S11);
        gp = s21.*s21./(1-s11.*s11);
    else
        error('MEASSP.GP: Argument must be a 2-port.');
    end
otherwise
    error('MEASSP.GP: Wrong number of arguments.');
end