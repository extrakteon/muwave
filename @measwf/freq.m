function val=freq(cIN)
%FREQ Retrieve the xparam object's frequency vector.
%   F = FREQ(MSP) returns a column-vector containing the frequencies in the xparam-object within MSP.

%   (c) Kristoffer Andersson & Christian Fager, Chalmers University of Technology, Sweden

% $Header$
% $Author: e7koffe $
% $Date: 2009-01-13 11:05:46 +0100 (ti, 13 jan 2009) $
% $Revision: 96 $ 
% $Log$
% Revision 1.4  2005/04/27 21:37:45  fager
% * Frequencies -> xparam
%
% Revision 1.3  2004/10/20 22:08:13  fager
% Help comments added
%

val=get(cIN.data,'Freq');
