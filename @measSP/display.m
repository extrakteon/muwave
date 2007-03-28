function display(cIN)
%DISPLAY Displays the various measSP object properties defined.

% $Header$
% $Author: fager $
% $Date: 2003-07-16 15:25:42 +0200 (Wed, 16 Jul 2003) $
% $Revision: 51 $ 
% $Log$
% Revision 1.3  2003/07/16 13:25:42  fager
% Uses new measstate and measmnt classes
%
% Revision 1.2  2003/07/16 10:42:38  fager
% Matlab help and CVS logging included. Modified for new measmnt and measstate
% classes.
%

INclass=measSP(cIN);
disp('Measurement info')
display(cIN.measmnt);
disp('Measurement state')
display(cIN.measstate);
disp('Measurement Data')
display(cIN.data);