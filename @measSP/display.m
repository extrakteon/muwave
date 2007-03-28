function display(cIN)
%DISPLAY Displays the various measSP object properties defined.

%   (c) Kristoffer Andersson & Christian Fager, Chalmers University of Technology, Sweden

% $Header$
% $Author: fager $
% $Date: 2004-10-21 00:08:13 +0200 (Thu, 21 Oct 2004) $
% $Revision: 219 $ 
% $Log$
% Revision 1.4  2004/10/20 22:06:21  fager
% Help comments added
%

INclass=measSP(cIN);
disp('Measurement info')
display(cIN.measmnt);
disp('Measurement state')
display(cIN.measstate);
disp('Measurement Data')
display(cIN.data);