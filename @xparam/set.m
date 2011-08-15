function cOUT=set(cIN,varargin)
% SET   Set xparam object properties.
%   SET(XP) returns the non-empty properties of the xparam
%   object XP.
%
%   XP = SET(XP,'FREQ',F) assigns the property FREQ of the xparam
%   object SP the values in F.
%
%   XP = set(XP,'P1',V1,'P2',V2,...) sets multiple xparam properties with a
%   single statement.
%
%   See also: GET

%   (c) Kristoffer Andersson & Christian Fager, Chalmers University of Technology, Sweden

% $Header$
% $Author: fager $
% $Date: 2005-05-03 15:22:41 +0200 (Tue, 03 May 2005) $
% $Revision: 270 $
% $Log$
% Revision 1.2  2005/05/03 13:22:41  fager
% Warning messages removed.
%
% Revision 1.1  2005/04/27 21:50:34  fager
% * Initial version
% * Frequencies -> xparam
%

property_argin = varargin;

if nargin == 1 % display only, set(m)
    display(cIN);
    return;
elseif nargin>2 & mod(nargin,2)==1   %set(cIN,'Prop1',val,'Prop2',val2,...)
    while length(property_argin) >= 2
        prop = property_argin{1};
        if ~isstr(prop), error('Properties must be strings'); end
        val = property_argin{2};
        property_argin = property_argin(3:end);
        switch lower(prop)
            case {'mtrx','arraymatrix','data'},
                if isa(val,'arraymatrix')
                    cIN.data = val;
%                     if length(val) ~= length(cIN.freq)
%                         warning('Frequency and data do not have the same length');
%                     end
                else
                    error('Value not of valid type');
                end
            case 'freq'
                if isa(val,'double')
%                     if length(val) ~= length(cIN.data)
%                         warning('Frequency and data do not have the same length');
%                     end
                     cIN.freq = reshape(val,[],1);
                elseif isempty(val)
                    cIN.freq = [];
                else
                    error('Value not of valid type');
                end
            case 'type'
                if isa(val,'char') & isvalid_type(upper(val))
                    cIN.type = upper(val);
                else
                    error('Value not of valid type');
                end
            case 'reference'
                if isa(val,'double')
                    cIN.reference = val;
                else
                    error('Value not of valid type');
                end
            case 'datacov'
                if isa(val,'arraymatrix')
                    s = size(val);
                    if (s(1) == s(2)) & (s(1) == 2*size(cIN.data,1)*size(cIN.data,2)) & (length(cIN.data) == length(val))
                        cIN.datacov = val;
                    else
                        error('Illegal size of covarance matrix');
                    end
                elseif isempty(val)
                    cIN.datacov = [];
                else
                    error('Value not of valid type');
                end

            otherwise,
                try
                    % Try if it is an attempt to set an measstate
                    % property?
                    cIN.data = set(cIN.data,prop,val);
                catch
                    error('Illegal assignment');
                end
        end
    end
    cOUT=cIN;
else
    error('Inproper number of input arguments');
end
