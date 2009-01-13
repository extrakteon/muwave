function c = isempty(a)
% ISEMPTY   Checks wheter the arraymatrix object is empty or not.

% $Header$
% $Author$
% $Date$
% $Revision$ 
% $Log$
% Revision 1.1  2005/04/27 21:50:17  fager
% * Initial version
% * Frequencies -> xparam
%
% Revision 1.3  2003/11/17 07:47:03  kristoffer
% *** empty log message ***

c = isempty(a.mtrx) | a.m == 0;