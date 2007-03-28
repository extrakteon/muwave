function val=length(cIN)
%LENGTH   Return the number of measurement frequencies.
%   L = LENGTH(MSP) returns the number of measurement frequencies in the meassp-object MSP.

%   (c) Kristoffer Andersson & Christian Fager, Chalmers University of Technology, Sweden

% $Header$
% $Author: fager $
% $Date: 2004-10-21 00:25:32 +0200 (Thu, 21 Oct 2004) $
% $Revision: 220 $ 
% $Log$
% Revision 1.4  2004/10/20 22:24:03  fager
% Help comments added
%
% Revision 1.3  2003/07/16 15:42:23  fager
% no message
%
% Revision 1.2  2003/07/16 15:41:57  fager
% Updated for the new meassp class definitions.



INclass=measSP(cIN);
val=length(INclass.data);
