function b = subsref(a,SX)
% SUBSREF   Overloads the .-operator
%
%   F = XP.FREQ equals the expression F = GET(XP,'FREQ');
%
%   See also: @XPARAM (class), GET, SET

%   (c) Kristoffer Andersson & Christian Fager, Chalmers University of Technology, Sweden

% $Header$
% $Author: koffer $
% $Date: 2005-05-03 14:34:14 +0200 (Tue, 03 May 2005) $
% $Revision: 269 $ 
%
% Revision 1.5  2004/10/20 22:24:09  fager
% Help comments added
%

S = SX(1); % the first indexing applies to meassp
NS = length(SX);
if NS > 1 % let the rest follow the object
    AUX = SX(2:end);
end

if isa(S.type,'char')
    switch S.type
    case '()'
        % check what sort of indexing we are dealing with
        K=length(S.subs);
        if K == 1
            index = S.subs{:};
            b = xparam(a.data(index),a.type,a.reference,a.freq(index),a.datacov);
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

% perform any remaining indexing operation
if NS > 1
    b = subsref(b,AUX);
end