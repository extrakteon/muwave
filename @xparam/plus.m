%
% XPARAM
% 
% Class for handling S,Z,Y and T-parameters
%
% CHANGES:
% 2002-01-03, Kristoffer Andersson
%             Major rewrite version
% 2002-01-08, Christian Fager
%             Fixed addition with scalar

% Overload operator+
function s3 = plus(s1,s2)

s1 = xparam(s1);

if isnumeric(s2) & length(s2)==1    % Scalar
    s3 = xparam(s1.data + s2, s1.type, s1.reference);
else
    s2 = xparam(s2);
    
    % Check if they are of the same type
    if s1.type ~= s2.type,
        s2 = convert(s2,s1.type);
        warning('XPARAM.PLUS: Arguments not of same type. Conversion performed'); 
    end
    
    if s1.reference ~= s2.reference,
        warning('XPARAM.PLUS: Arguments do not have the same reference impedence. Conversion NOT performed'); 
    end
    s3 = xparam(s1.data + s2.data, s1.type, s1.reference);
end