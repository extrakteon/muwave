function cOUT=set(cIN,varargin)
% SET   Set waveform object properties.
%   SET(WF) returns the non-empty properties of the waveform
%   object WF.
%
%   WF = SET(WF,'FREQ',F) assigns the property FREQ of the waveform
%   object WF the values in F.
%
%   WF = set(WF,'P1',V1,'P2',V2,...) sets multiple waveform properties with a
%   single statement.
%
%   See also: GET
%
% $Header$
% $Author: $
% $Date: $
% $Revision: $ 
% $Log$
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
            case 'a'
                cIN.data(1,:) = val;
            case 'b'
                cIN.data(2,:) = val;
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
