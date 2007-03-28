function gmsg = gmsg(a)
% Return the maximum stable gain of a two port
% 2002-04-11, Kristoffer Andersson
%             First version

switch nargin
case 1
    if get(a.Data,'ports') == 2
        s21 = abs(a.Data.S21);
        s12 = abs(a.Data.S12);
        gmsg = abs(s21)./abs(s12);
    else
        error('MEASSP.GMSG: Argument must be a 2-port.');
    end
otherwise
    error('MEASSP.GMSG: Wrong number of arguments.');
end