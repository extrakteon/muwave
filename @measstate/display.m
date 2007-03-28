function display(cIN)
%DISPLAY    Display measstate object properties.
%   display(M) displays the non-empty properties of 
%   the measstate object M.

% $Header$
% $Author: fager $
% $Date: 2005-04-27 10:21:56 +0200 (Wed, 27 Apr 2005) $
% $Revision: 252 $ 
% $Log$
% Revision 1.3  2005/04/27 08:21:56  fager
% Reformatted output format.
%
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
            disp(sprintf('\t%s:\t%g',Prop,Val));
        elseif isnumeric(Val) & length(Val)>1
            disp(sprintf('\t%s,min:\t%g',Prop,min(Val)));
            disp(sprintf('\t%s,max:\t%g',Prop,max(Val)));
        elseif isstr(Val)
            disp(sprintf('\t%s:\t%s',Prop,Val));
        end
    end
end