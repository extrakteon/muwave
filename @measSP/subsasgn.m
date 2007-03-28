function cOUT = subsasgn(cIN,S,b)
%SUBSASGN    Overloads the subsasgn operator.
%   M.P = V equals M = set(M,'P',V)
%
%   Example
%   >> M.S11 = rand(201,1);

% $Header$
% $Author: fager $
% $Date: 2003-07-18 15:51:11 +0200 (Fri, 18 Jul 2003) $
% $Revision: 93 $ 
% $Log$
% Revision 1.2  2003/07/18 13:51:11  fager
% Matlab-standardized help and CVS-logging added.
%
% Revision 1.3  2003/07/18 07:54:04  fager
% msp.Data -> msp.data and error handling improved.
%
% Revision 1.2  2003/07/16 15:39:39  fager
% Updated for the new meassp class definitions.
%

cOUT = cIN;
if length(S)~=1, error('Only simple assignments are allowed.');end;
switch S.type
    case {'()','{}'}
        try
            cOUT.data = subsasgn(cIN.data,S,b);
        catch
            error('Illegal assignment type.');
        end
    case '.'
        states = get(cIN.measstate);
        infos = get(cIN.measmnt);
        if ismember(lower(S.subs),lower(states))
            cOUT.measstate = set(cOUT.measstate,S.subs,b);
        elseif ismember(lower(S.subs),lower(infos))
            cOUT.measmnt = set(cOUT.measmnt,S.subs,b);
        elseif strcmpi(S.subs,'data') & isa(b,'xparam')
            cOUT.data = b;
        else
            try
                cOUT.data = subsasgn(cIN.data,S,b);
            catch
                error('Illegal assignment.');
            end
        end
end