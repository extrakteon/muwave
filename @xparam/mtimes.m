function c = mtimes(a,b)
%MTIMES Overloads the * operator.

% $Header$
% $Author: fager $
% $Date: 2003-08-25 13:36:49 +0200 (Mon, 25 Aug 2003) $
% $Revision: 131 $ 
% $Log$
% Revision 1.3  2003/08/25 11:36:49  fager
% Conversion to same type removed.
%

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

a = xparam(a);
if isnumeric(b) & length(b)==1    % Scalar
    c = xparam(a.data*b, a.type, a.reference);
else
    b = xparam(b);
     
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
