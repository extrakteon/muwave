function val=freq(cIN)
%FREQ Retrieve the xparam object's frequency vector.
%   F = FREQ(XP) returns a column-vector containing the frequencies in the xparam-object XP.

%   (c) Kristoffer Andersson & Christian Fager, Chalmers University of Technology, Sweden

% $Header$
% $Author: fager $
% $Date: 2005-04-27 23:50:34 +0200 (Wed, 27 Apr 2005) $
% $Revision: 264 $ 
% $Log$
% Revision 1.1  2005/04/27 21:50:17  fager
% * Initial version
% * Frequencies -> xparam
%
% Revision 1.3  2004/10/20 22:08:13  fager
% Help comments added
%

val=get(cIN,'Freq');
