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
        % check what sort of indexing we are dealing with
        K=length(S.subs);
        if K == 1
            index = S.subs{:};
            b = xparam(a.data(index),a.type,a.reference);
        elseif K == 2
            % we are dealing with a vector extraction
            x = S.subs{1};
            y = S.subs{2};
            mtrx = get(a,'mtrx');
            b = squeeze(mtrx(x,y,:));
        else
            error('XPARAM.SUBSREF: Unknown error.');
        end
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