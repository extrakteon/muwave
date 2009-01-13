function c = mtimes(a,b)
%MTIMES Overloads the * operator.

% $Header$
% $Author$
% $Date$
% $Revision$ 
% $Log$
% Revision 1.6  2005/05/11 12:37:42  koffer
% Supports both pos- and premultiplication with doubles.
%
% Revision 1.5  2005/05/11 10:17:24  fager
% Compability with new version of xparam
%
% Revision 1.4  2004/10/25 10:54:00  koffer
% Bugfix. Let arraymatrix handle more of the argument checking.
%
% Revision 1.3  2003/08/25 11:36:49  fager
% Conversion to same type removed.
%


if isa(b,'double')
    % a is a xparam-object
    c = xparam(a.data*b, a.type, a.reference, a.freq, a.datacov);
elseif isa(a,'double')
    % b is a xparam-object
    c = xparam(a*b.data, b.type, b.reference, b.freq, b.datacov);
else
    % both objects are xparam or some other weird thing
    if a.reference ~= b.reference,
        warning('XPARAM.MTIMES: Arguments do not have the same reference impedence. Conversion NOT performed'); 
    end
    ad = a.data;
    bd = b.data;
    data = ad * bd;
    c = xparam(data, a.type, a.reference, a.freq, a.datacov);
end
%
% Internal functions
%
