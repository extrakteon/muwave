function val=freq(cIN)
%FREQ   Retrieve the measSP object's frequency vector.

% $Header$
% $Author: fager $
% $Date: 2003-07-16 17:27:28 +0200 (Wed, 16 Jul 2003) $
% $Revision: 61 $ 
% $Log$
% Revision 1.2  2003/07/16 15:27:28  fager
% Updated.
%
% Revision 1.2  2003/07/16 15:17:54  fager

INclass=measSP(cIN);
val=get(INclass.measstate,'Freq');
