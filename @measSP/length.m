function val=length(cIN)
%LENGTH   Return the number of measurement frequencies.

% $Header$
% $Author: fager $
% $Date: 2003-07-16 17:42:23 +0200 (Wed, 16 Jul 2003) $
% $Revision: 63 $ 
% $Log$
% Revision 1.3  2003/07/16 15:42:23  fager
% no message
%
% Revision 1.2  2003/07/16 15:41:57  fager
% Updated for the new meassp class definitions.



INclass=measSP(cIN);
val=length(INclass.data);
