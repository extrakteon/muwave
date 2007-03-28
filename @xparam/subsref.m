%
% XPARAM
% 
% Class for handling S,Z,Y and T-parameters
%
% CHANGES:
% 2002-01-04, Kristoffer Andersson
%             First version
%
% Overloads method subsref, eg A = B(S)
function b = subsref(a,S)

if isa(S.type,'char')
    switch S.type
    case '()'
        index = S.subs{:};
        b = xparam(a.data(index),a.type,a.reference);
    case '.'
        b = get(a,S.subs);
    otherwise
        if S.type ~= '()',
            error('XPARAM.SUBSREF: Unsupported indexing.');
        end
    end
else
    error('XPARAM.SUBSREF: Unknown error.');
end

% internal functions