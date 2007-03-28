function b = subsref(a,S)
%SUBSREF Overloads the subsref operator.
%   V = M.P equals V = get(M,P)
%
%   M2 = M(k) returns the k'th sweep object. 
%
%   See also: SUBSASGN, GET, SET, ADD

%   (c) Kristoffer Andersson & Christian Fager, Chalmers University of Technology, Sweden

% $Header$
% $Author: fager $
% $Date: 2004-10-20 19:01:34 +0200 (Wed, 20 Oct 2004) $
% $Revision: 218 $ 
% $Log$
% Revision 1.4  2004/10/20 17:01:34  fager
% Help comments added
%

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
