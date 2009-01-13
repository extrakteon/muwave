function display(cIN)
%DISPLAY    Display measstate object properties.
%   display(M) displays the non-empty properties of
%   the measstate object M.

% $Header$
% $Author$
% $Date$
% $Revision$
% $Log$
% Revision 1.6  2005/05/12 21:46:55  fager
% Proper display of multidimensional state variables
%
% Revision 1.5  2005/05/11 10:13:45  fager
% Allows diplay of cell vector properties.
%
% Revision 1.4  2005/05/02 14:16:59  fager
% Allows cell-vector state variables
%
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
            if sum(size(Val)>1)<2 & isreal(Val)
                disp(sprintf('\t%s,min:\t%g',Prop,min(Val)));
                disp(sprintf('\t%s,max:\t%g',Prop,max(Val)));
            else
                tx = num2str(size(Val));
                [s,f,t] = regexp(tx,'(\d+)');
                formatstr = '';
                i = 1;
                stop = isempty(t);
                while ~stop
                    stop = (i + 1) > length(t);
                    if stop
                        formatstr = strcat(formatstr,tx(t{i}(1):t{i}(2)));
                    else
                        formatstr = strcat(formatstr,tx(t{i}(1):t{i}(2)),'x');
                        i = i + 1;
                    end
                end
                disp(sprintf('\t%s: [%s]',Prop,formatstr));
            end
        elseif isstr(Val)
            disp(sprintf('\t%s:\t%s',Prop,Val));
        elseif iscell(Val)
            disp(sprintf('\t%s:\t{%d x %d} cell array',Prop,size(Val,1),size(Val,2)));
        end
    end
end