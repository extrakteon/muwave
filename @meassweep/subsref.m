function b = subsref(a,SX)
%SUBSREF Overloads the subsref operator.
%   V = M.P equals V = get(M,P)
%
%   M2 = M(k) returns the k'th sweep object. 
%
%   See also: SUBSASGN, GET, SET, ADD

%   (c) Kristoffer Andersson & Christian Fager, Chalmers University of Technology, Sweden

% $Header$
% $Author$
% $Date$
% $Revision$ 
% $Log$
% Revision 1.5  2005/05/12 21:52:26  fager
% Nested indexing implemented also for meassweep, e.g. mswp(1).S11(20)
%
% Revision 1.4  2004/10/20 17:01:34  fager
% Help comments added
%

S = SX(1); % the first indexing applies to meassp
NS = length(SX);
if NS > 1 % let the rest follow the object
    AUX = SX(2:end);
end

switch S.type
case '()', % The n'th measmnt object
    if length(S.subs{:})==1
        b = a.data{S.subs{:}};
    else
        b = a;
        b.data = a.data(S.subs{:});
    end
case '.'
    try
        for k=1:length(a.data)
            b = cat(2,b,subsref(a.data{k},S));
        end
    catch
        b = get(a,S.subs);        
    end
otherwise
    error('Specified indexing not implemented.');
end

% perform any remaining indexing operation
if NS > 1
    b = subsref(b,AUX);
end
