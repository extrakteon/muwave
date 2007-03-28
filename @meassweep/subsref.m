function b = subsref(a,S)
%SUBSREF    Overloads the subsref operator.
%   V = M.P equals V = get(M,P)
%
%   M2 = M(k) returns the k'th sweep object. 

% $Header$
% $Author: fager $
% $Date: 2003-07-21 10:32:28 +0200 (Mon, 21 Jul 2003) $
% $Revision: 105 $ 
% $Log$
% Revision 1.2  2003/07/21 08:32:28  fager
% Initial. Matlab help and CVS logging added.
%

switch S.type
case '()', % The n'th measmnt object
    if length(S.subs{:})==1
        b = a.data{S.subs{:}};
    else
        b = a;
        b.data = [a.data{S.subs{:}}];
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
