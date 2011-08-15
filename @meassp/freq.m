function val=freq(cIN)
%FREQ Retrieve the xparam object's frequency vector.
%   F = FREQ(MSP) returns a column-vector containing the frequencies in the xparam-object within MSP.

%   (c) Kristoffer Andersson & Christian Fager, Chalmers University of Technology, Sweden

% $Header$
% $Author: fager $
% $Date: 2005-04-27 23:37:58 +0200 (Wed, 27 Apr 2005) $
% $Revision: 258 $ 
% $Log$
% Revision 1.4  2005/04/27 21:37:45  fager
% * Frequencies -> xparam
%
% Revision 1.3  2004/10/20 22:08:13  fager
% Help comments added
%

val=get(cIN.data,'Freq');
