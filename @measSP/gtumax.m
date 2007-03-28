function gtu = gtumax(a)
% Return the maximum unilateral transducer gain of a two port
% 2002-01-09, Kristoffer Andersson
%             First version

switch nargin
case 1
    if get(a.Data,'ports') == 2
        s21 = abs(a.Data.S21);
        s11 = abs(a.Data.S11);
        s22 = abs(a.Data.S22);
        gtu = s21.*s21./((1-s11.*s11).*(1-s22.*s22));
    else
        error('MEASSP.GTUMAX: Argument must be a 2-port.');
    end
otherwise
    error('MEASSP.GTUMAX: Wrong number of arguments.');
end