function c = isempty(a)
% ISEMPTY   Checks wheter the arraymatrix object is empty or not.

% $Header$
% $Author: fager $
% $Date: 2005-04-27 23:50:34 +0200 (Wed, 27 Apr 2005) $
% $Revision: 264 $ 
% $Log$
% Revision 1.1  2005/04/27 21:50:17  fager
% * Initial version
% * Frequencies -> xparam
%
% Revision 1.3  2003/11/17 07:47:03  kristoffer
% *** empty log message ***

c = isempty(a.mtrx) | a.m == 0;