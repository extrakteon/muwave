function cOUT=set(cIN,varargin)
%SET    Set meassweep object properties.
%   set(M) displays the non-empty properties of the meassweep
%   object M.
%
%   M=set(M,'P1',V) assigns the property P1 of the measmnt
%   object M the value V. If the property does not exist, it tries to set the 
%   the corresponding object's measmmnt, measstate, or xparam properties.
%
%   M=set(M,'P1',V1,'P2',V2,...) sets multiple measSP properties with a
%   single statement.

% $Header$
% $Author: kristoffer $
% $Date: 2003-07-23 10:35:37 +0200 (Wed, 23 Jul 2003) $
% $Revision: 112 $ 
% $Log$
% Revision 1.3  2003/07/23 08:35:37  kristoffer
% Fixed an unmatched "end"
%
% Revision 1.2  2003/07/21 08:32:28  fager
% Initial. Matlab help and CVS logging added.
%
% Revision 1.4  2003/07/16 15:17:54  fager
% Optimized for speed.
%
% Revision 1.3  2003/07/16 13:25:12  fager
% Uses new measstate and measmnr methods and try/catch.
%
% Revision 1.2  2003/07/16 13:21:28  fager
% Method addprop replaces the possibility to add properties directly in set.
%

property_argin = varargin;
INclass=meassweep(cIN);

if nargin == 1 % display only, set(m)
    display(INclass);
elseif nargin>2 & mod(nargin,2)==1   %set(cIN,'Prop1',val,'Prop2',val2,...)
    while length(property_argin) >= 2
        prop = property_argin{1};
        if ~isstr(prop)
            error('Properties must be strings');
        end
        val = property_argin{2};
        property_argin = property_argin(3:end);
        switch lower(prop)
            case 'measmnt'
                if isa(val,'measmnt')
                    INclass.measmnt=val;
                else
                    error('Value not of valid type');
                end
            case 'sweeptype'
                if isstr(val)
                    INclass.sweeptype = val;
                end
            otherwise
                try
                    % Is it an attempt to set an measmnt
                    % property?
                    INclass.measmnt = set(INclass.measmnt,prop,val);
                catch
                    error('Illegal input argument.');
                end
        end
        cOUT=INclass;
    end
else
    error('Inproper number of input arguments');
end