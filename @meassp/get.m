function val=get(cIN,prop_name)
%GET Get meassp object properties.
%   V=get(M,'P1') returns the value of the meassp-object M property P1.
%   If the property is not found in the meassp-object, it is tried to be extracted from the
%   xparam or measstate objects that build up the meassp object.
%
%   See also: SET

%   (c) Kristoffer Andersson & Christian Fager, Chalmers University of Technology, Sweden

% $Header$
% $Author: koffe $
% $Date: 2009-01-13 11:05:46 +0100 (ti, 13 jan 2009) $
% $Revision: 96 $ 
% $Log$
% Revision 1.5  2005/04/27 21:37:58  fager
% * Frequencies -> xparam
%
% Revision 1.4  2004/10/20 22:19:23  fager
% Help comments added
%

INclass=meassp(cIN);
if ~isstr(prop_name), error('Property must be a string.'); end;
switch lower(prop_name)
    case 'data',
        val=INclass.data;
    case 'measstate',
        val=INclass.measstate;
    case 'measmnt',
        val=INclass.measmnt;
    otherwise
        try		% Try if it works if operated on the measstate object
            val = get(INclass.measstate,prop_name);
        catch err
            try		% Try if it works if operated on the measmnt object
                val = get(INclass.measmnt,prop_name);
            catch err  % It is a data object - or?
                try
                val = get(INclass.data,prop_name);
                catch err
                    error('Unknown property.');
                end
            end
        end
end
