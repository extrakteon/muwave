function gt = gt(a)
% Return the transducer gain of a two port
% 2002-01-09, Kristoffer Andersson
%             First version

switch nargin
case 1
    if get(a.Data,'ports') == 2
        s21 = abs(a.Data.S21);
        gp = s21.*s21;
    else
        error('MEASSP.GT: Argument must be a 2-port.');
    end
otherwise
    error('MEASSP.GT: Wrong number of arguments.');
end