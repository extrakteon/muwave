function display(cIN)
%DISPLAY Displays the various measwf object properties defined.

%   (c) Kristoffer Andersson & Christian Fager, Chalmers University of Technology, Sweden

% $Header$
% $Author: koffe $
% $Date: 2009-01-13 11:05:46 +0100 (ti, 13 jan 2009) $
% $Revision: 96 $ 
% $Log$
%

INclass=measwf(cIN);
disp('Measurement info')
display(cIN.measmnt);
disp('Measurement state')
display(cIN.measstate);
display(cIN.data);