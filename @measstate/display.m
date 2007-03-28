function display(cIN)
% Method to display the properties of a measmnt class object.

% $Header$
% $Author: kristoffer $
% $Date: 2003-06-17 14:17:51 +0200 (Tue, 17 Jun 2003) $
% $Revision: 2 $ 
% $Log$
% Revision 1.1  2003/06/17 12:17:52  kristoffer
% Initial revision
%
% Revision 1.4  2002/03/12 11:42:03  fager
% Changed to use arbitrary measurement state properties
%

INclass=measstate(cIN);
if isempty(INclass.Props)
    disp('- Empty measstate object -');
else
    for k=1:length(INclass.Props)
        Prop=INclass.Props{k};
        Val=INclass.Values{k};
        if length(Val)==1 & isnumeric(Val)
            disp(sprintf('\t%s:\t%G',Prop,Val));
        elseif isnumeric(Val) & length(Val)>1
            disp(sprintf('\t%s,min:\t%G',Prop,min(Val)));
            disp(sprintf('\t%s,max:\t%G',Prop,max(Val)));
        elseif isstr(Val)
            disp(sprintf('\t%s:\t%s',Prop,Val));
        end
    end
end