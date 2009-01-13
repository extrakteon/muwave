function display(cIN)
%DISPLAY    Display measmnt object properties.
%   display(M) displays the non-empty properties of 
%   the measmnt object M.

% $Header$
% $Author$
% $Date$
% $Revision$ 
% $Log$
% Revision 1.6  2005/05/02 14:16:16  fager
% Allows cell-vector state variables
%
% Revision 1.5  2003/07/16 14:46:47  fager
% no message
%
% Revision 1.4  2003/07/16 10:41:51  fager
% Modified display alignment.
%
% Revision 1.3  2003/07/16 09:23:00  fager
% Matlab Help and CVS logging info added.
%
%

INclass=measmnt(cIN);

for k=1:length(INclass.props)
    property = INclass.props{k};
    value = INclass.values{k};
    if isnumeric(value)
        valstr = num2str(value);
    elseif isstr(value)
        valstr = value;
    elseif iscell(value)
        valstr = sprintf('{%d x %d} cell array',size(value,1),size(value,2));
    else
        continue;
    end
    disp(['    ',INclass.props{k},' : ',valstr]);
end