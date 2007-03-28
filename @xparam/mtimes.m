%
% XPARAM
% 
% Class for handling S,Z,Y and T-parameters
%
% CHANGES:
% 2002-01-03, Kristoffer Andersson
%             Major rewrite version
%
% 2002-01-08, Christian Fager
%             Fixed multiplication with scalar.
%
% Overloads operator*
function c = mtimes(a,b)

a = xparam(a);
if isnumeric(b) & length(b)==1    % Scalar
    c = xparam(a.data*b, a.type, a.reference);
else
    b = xparam(b);
    
    % Check if they are of the same type
    if a.type ~= b.type,
        b = convert(b,a.type);
        warning('XPARAM.MTIMES: Arguments not of same type. Conversion performed'); 
    end
    
    if a.reference ~= b.reference,
        warning('XPARAM.MTIMES: Arguments do not have the same reference impedence. Conversion NOT performed'); 
    end
    
    ad = a.data;
    bd = b.data;
    data = ad * bd;
    
    c = xparam(data, a.type, a.reference);
    
end
%
% Internal functions
%
