function display(cIN)
%DISPLAY Displays the various measwf object properties defined.

%   (c) Kristoffer Andersson & Christian Fager, Chalmers University of Technology, Sweden

% $Header$
% $Author$
% $Date$
% $Revision$ 
% $Log$
%

INclass=measwf(cIN);
disp('Measurement info')
display(cIN.measmnt);
disp('Measurement state')
display(cIN.measstate);
display(cIN.data);