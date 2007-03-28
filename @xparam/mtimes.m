function c = mtimes(a,b)
%MTIMES Overloads the * operator.

% $Header$
% $Author: koffer $
% $Date: 2004-10-25 12:54:00 +0200 (Mon, 25 Oct 2004) $
% $Revision: 225 $ 
% $Log$
% Revision 1.4  2004/10/25 10:54:00  koffer
% Bugfix. Let arraymatrix handle more of the argument checking.
%
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
if isa(b,'double')
    % 2004/10/22 changed to a more general setting, thus transfers handling to
    % arraymatrix...
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
