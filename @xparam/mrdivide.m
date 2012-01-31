%
% XPARAM
% 
% Class for handling S,Z,Y and T-parameters
%
% CHANGES:
% 2003-08-25, Christian Fager
%             First version
%
% Overloads operator /
function c = mrdivide(a,b)

a = xparam(a);
if isnumeric(b) & size(b,2)==1    % Scalar
    c = xparam(a.data.*b, a.type, a.reference, a.freq);
else
    b = xparam(b);
    
    % Check if they are of the same type
    if a.type ~= b.type,
        b = convert(b,a.type);
        warning('Arguments not of same type. Conversion performed'); 
    end
    
    if a.reference ~= b.reference,
        warning('Arguments do not have the same reference. Conversion NOT performed'); 
    end
    
    data = a.data / b.data;
    
    c = xparam(data, a.type, a.reference, a.freq);
    
end
%
% Internal functions
%
