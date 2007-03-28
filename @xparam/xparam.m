%
% XPARAM
% 
% Class for handling S,Z,Y and T-parameters
%
%

function l = xparam(a,b,c)
%
% Constructor for generic X-parameters class
% 

if nargin==0
    % S-parameters default & 50 Ohms system impedance
    p.type = 'S';
    p.reference = 50;
    p.data = arraymatrix;
    l = class(p, 'xparam');
else
    if isa(a,'xparam')
        l = a;
    else
        a = arraymatrix(a);
        if nargin==1
            % xparam(data_mtrx)
            % Use type = Z as default!
            % Use reference = 50 as default!
            p.type = 'Z';
            p.reference = 50;
            p.data = a;
            l = class(p, 'xparam');
        elseif nargin==2  & isvalid_type(b)
            % xparam(arraymatrix, type)
            % Use reference = 50 as default!
            p.type = b;
            p.reference = 50;
            p.data = a;
            l = class(p, 'xparam');
        elseif nargin==3  & isvalid_type(b) & isa(c,'double')
            % xparam(arraymatrix, type, reference)
            p.type = b;
            p.reference = c;
            p.data = a;
            l = class(p, 'xparam');
        else
            error('XPARAM.XPARAM: Invalid input argument(s).')   
        end
    end
end

%
% Internal functions
%

