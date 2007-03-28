function display(cIN)
%DISPLAY    Display measstate object properties.
%   display(M) displays the non-empty properties of 
%   the measstate object M.

% $Header$
% $Author: fager $
% $Date: 2003-07-16 11:59:59 +0200 (Wed, 16 Jul 2003) $
% $Revision: 40 $ 
% $Log$
% Revision 1.2  2003/07/16 09:59:54  fager
% Matlab help added.
%
% Revision 1.1.1.1  2003/06/17 12:17:52  kristoffer
%
%
% Revision 1.4  2002/03/12 11:42:03  fager
% Changed to use arbitrary measurement state properties
%

INclass=measstate(cIN);
if isempty(INclass.props)
    disp('- Empty measstate object -');
else
    for k=1:length(INclass.props)
        Prop=INclass.props{k};
        Val=INclass.values{k};
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