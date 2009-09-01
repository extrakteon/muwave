function b = subsref(a,SX)
% SUBSREF   Overloads the .-operator
%
%   F = XP.FREQ equals the expression F = GET(XP,'FREQ');
%
%   See also: @WAVEFORM (class), GET, SET

%   (c) Kristoffer Andersson & Christian Fager, Chalmers University of Technology, Sweden

% $Header$
% $Author: $
% $Date:  $
% $Revision: $ 
% $Log: $
%

S = SX(1); % the first indexing applies to time or frequency depending on context
NS = length(SX);
if NS > 1 % let the rest follow the object
    AUX = SX(2:end);
end

if isa(S.type,'char')
    switch S.type
%    case '()'
%         % check what sort of indexing we are dealing with
%         K=length(S.subs);
%         if K == 1
%             index = S.subs{:};
%             b = xparam(a.data(index),a.type,a.reference,a.freq(index),a.datacov);
%         elseif K == 2
%             % we are dealing with a vector extraction
%             x = S.subs{1};
%             y = S.subs{2};
%             mtrx = get(a,'mtrx');
%             b = squeeze(mtrx(x,y,:));
%         else
%            error('WAVEFORM.SUBSREF: Unknown error.');
%        end
    case '.'
        b = get(a,S.subs);
    otherwise
        if S.type ~= '()',
            error('WAVEFORM.SUBSREF: Unsupported indexing.');
        end
    end
else
    error('WAVEFORM.SUBSREF: Unknown error.');
end

% perform any remaining indexing operation
if NS > 1
    b = subsref(b,AUX);
end