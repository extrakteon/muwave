function b = subsref(a,S)

% Calls the same function for the underlying measurement object.
% Created 02-01-06 by Christian Fager
%
% Revision history.
% v1.0 -- Date 02-01-06

% Calls xparam/subsref
b=[];
switch S.type
case '()', % The n'th measmnt object
    b = a.Data{S.subs{:}};
case '.'
    try
        for k=1:length(a.Data)
            b = cat(2,b,subsref(a.Data{k},S));
        end
    catch
        b = get(a,S.subs);        
    end
otherwise
    error('Specified indexing not implemented.');
end
