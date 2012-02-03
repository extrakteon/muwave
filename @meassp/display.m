function display(cIN)
%DISPLAY Displays the various meassp object properties defined.

%   (c) Kristoffer Andersson & Christian Fager, Chalmers University of Technology, Sweden

% $Header$
% $Author: koffe $
% $Date: 2009-01-13 11:05:46 +0100 (ti, 13 jan 2009) $
% $Revision: 96 $ 
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