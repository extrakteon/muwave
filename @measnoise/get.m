function val=get(cIN,prop_name)
% Method to access the properties of a measNoise object.

% Version 1.0
% Created 02-01-10 by Christian Fager
%
% Revision history.
% v1.0 -- Date 02-01-10
% Created.


INclass=measNoise(cIN);
switch prop_name
case 'Fmin'
    val = INclass.Fmin;
case 'Rn'
    val = INclass.Rn;
case 'GammaOpt'
    val = INclass.GammaOpt;
case 'NF'
    val = INclass.NF;
otherwise
    try
        val=get(INclass.measmnt,prop_name);
    catch err
        try
            val=get(INclass.State,prop_name);
        catch err
            error(['Unknown property "',prop_name,'".']);
        end
    end
end
