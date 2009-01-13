function b = subsref(a,S)

% Calls the same function for the underlying meassp object.
% Created 02-01-06 by Christian Fager
% Calls xparam/subsref

% $Header$
% $Author$
% $Date$
% $Revision$ 
% $Log$
% Revision 1.1  2003/06/17 12:17:53  kristoffer
% Initial revision
%
% Revision 1.1  2002/01/17 15:19:18  fager
% Initial
%
%

switch S.type
case {'()','{}'}
    
    b=a;
    b.meassp = subsref(a.meassp,S);
case '.'
    try
        b = get(a,S.subs);
    catch
        b = subsref(a.meassp,S);
    end
otherwise
    error('Illegal subscripting');
end 