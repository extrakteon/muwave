function val=freq(cIN)
%FREQ Retrieve the measSP object's frequency vector.
%   F = FREQ(MSP) returns a column-vector containing the frequencies in the meassp-object MSP.

%   (c) Kristoffer Andersson & Christian Fager, Chalmers University of Technology, Sweden

% $Header$
% $Author: fager $
% $Date: 2004-10-21 00:08:13 +0200 (Thu, 21 Oct 2004) $
% $Revision: 219 $ 
% $Log$
% Revision 1.3  2004/10/20 22:08:13  fager
% Help comments added
%

INclass=measSP(cIN);
val=get(INclass.measstate,'Freq');
