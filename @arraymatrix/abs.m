function c = abs(a)
% ABS   Returns the absolute values of the arraymatrix elements.

% $Header$
% $Author: koffer $
% $Date: 2006-08-15 14:47:55 +0200 (Tue, 15 Aug 2006) $
% $Revision: 304 $ 
% $Log$
% Revision 1.2  2005/04/27 21:29:19  fager
% Version logging added.
%
% Revision 1.3  2003/11/17 07:47:03  kristoffer
% *** empty log message ***

c = arraymatrix(a);
mtrx = a.mtrx;
mtrx = abs(mtrx);
c.mtrx = mtrx; 
