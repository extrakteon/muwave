function display(cIN)
%DISPLAY Displays the various meassp object properties defined.

%   (c) Kristoffer Andersson & Christian Fager, Chalmers University of Technology, Sweden

% $Header$
% $Author: fager $
% $Date: 2005-04-27 23:44:52 +0200 (Wed, 27 Apr 2005) $
% $Revision: 261 $ 
% $Log$
% Revision 1.5  2005/04/27 21:35:07  fager
% * Changed from measSP to meassp.
%
% Revision 1.4  2004/10/20 22:06:21  fager
% Help comments added
%

INclass=meassp(cIN);
disp('Measurement info')
display(cIN.measmnt);
disp('Measurement state')
display(cIN.measstate);
display(cIN.data);