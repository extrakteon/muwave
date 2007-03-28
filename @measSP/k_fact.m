function k = k_fact(a)
% Return the k-factor of a two port
% 2002-01-09, Kristoffer Andersson
%             First version

switch nargin
case 1
    if get(a.Data,'ports') == 2
        s1221 = a.Data.S12.*a.Data.S21;
        s11 = a.Data.S11;
        s22 = a.Data.S22;
        k = (1 + abs(s11.*s22 - s1221).^2 - abs(s11).^2 - abs(s22).^2)./(2*abs(s1221));
    else
        error('MEASSP.K_FACT: Argument must be a 2-port.');
    end
otherwise
    error('MEASSP.K_FACT: Wrong number of arguments.');
end