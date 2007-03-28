function val=get(cIN,prop_name)
% Method to access the properties of a measSP object.

% $Header$
% $Author: kristoffer $
% $Date: 2003-06-17 14:17:51 +0200 (Tue, 17 Jun 2003) $
% $Revision: 2 $ 
% $Log$
% Revision 1.1  2003/06/17 12:17:52  kristoffer
% Initial revision
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
switch prop_name
case 'Data',
    val=INclass.Data;
case 'State',
    val=INclass.State;
case 'measmnt',
    val=INclass.measmnt;
otherwise
    try		% Try if it works if operated on the data object
        val = get(INclass.Data,prop_name);
    catch
        try		% Try if it works if operated on the measmnt object
            val = get(INclass.measmnt,prop_name);
        catch
            try		% Try if it works if operated on the measstate object
                val = get(INclass.State,prop_name);
            catch
                error(['Unknown property "',prop_name,'".']);
            end
        end
    end
end
