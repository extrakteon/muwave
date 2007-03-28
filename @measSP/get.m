function val=get(cIN,prop_name)
%GET    Get measSP object properties.
%   V=get(M,'P1') returns the value of the measSP-property P1.

% $Header$
% $Author: fager $
% $Date: 2003-07-17 10:27:20 +0200 (Thu, 17 Jul 2003) $
% $Revision: 67 $ 
% $Log$
% Revision 1.3  2003/07/17 08:27:20  fager
% Updated error handling.
%
% Revision 1.2  2003/07/16 15:17:54  fager
% Optimized for speed.
%
% Revision 1.1.1.1  2003/06/17 12:17:52  kristoffer
%
%
% Revision 1.7  2002/03/12 11:42:45  fager
% Uses a try-catch approach on subsequent properties of the
% meassp object
%
% Revision 1.6  2002/01/17 15:20:14  fager
% Added CVS support
% Added extraction of the measmnt and state members
%
%

INclass=measSP(cIN);
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
        catch
            try		% Try if it works if operated on the measmnt object
                val = get(INclass.measmnt,prop_name);
            catch   % It is a data object - or?
                try
                val = get(INclass.data,prop_name);
            catch
                error('Unknown property.');
            end
            end
        end
end
