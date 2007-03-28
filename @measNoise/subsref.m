function b = subsref(a,S)

% Calls the same function for the underlying xparam object.
% Created 02-01-10 by Christian Fager
%
% Revision history.
% v1.0 -- Date 02-01-10

switch S.type
case '.'
    b = get(a,S.subs);
otherwise,
    error('Illegal subscripting');
end

