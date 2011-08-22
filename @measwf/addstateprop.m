function cOUT=addstateprop(cIN,varargin)
%ADDSTATEPROP   Add MEASSTATE properties to a MEASSP object.
%   addprop(M,'P',V) creates a new property, P, with value V
%   to the MEASSP object M.

%   addprop(M,'P1',V1,'P2',V2,..) adds multiple properties in a single statement.

% $Header$
% $Author: e7koffe $
% $Date: 2009-01-13 11:05:46 +0100 (ti, 13 jan 2009) $
% $Revision: 96 $ 
% $Log$
% Revision 1.1  2005/05/02 14:16:30  fager
% Initial version
%
property_argin = varargin;
INclass=meassp(cIN);

mstate = get(INclass,'measstate');

if nargin == 1 % display only, set(m)
    display(mstate);
    return;
elseif nargin>2 & mod(nargin,2)==1   %set(cIN,'Prop1',val,'Prop2',val2,...)
    while length(property_argin) >= 2
        prop = property_argin{1};
        val = property_argin{2};
        property_argin = property_argin(3:end);
        if ~isstr(prop), error('Properties must be strings.'), end;
        if isempty(val), continue; end;
        mstate = addprop(mstate,prop,val);
    end
    cOUT=INclass;
    cOUT = set(cOUT,'measstate',mstate);
else
    error('Inproper number of input arguments');
end
