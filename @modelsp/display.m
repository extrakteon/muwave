function display(cIN)
% Method to display the properties of a meassp object.

% $Header$
% $Author$
% $Date$
% $Revision$ 
% $Log$
% Revision 1.2  2005/04/27 21:35:25  fager
% no message
%
% Revision 1.1.1.1  2003/06/17 12:17:53  kristoffer
%
%
% Revision 1.1  2002/01/17 15:20:29  fager
% Initial
%
%

disp('Measurement info')
display(get(cIN,'measmnt'));
disp('Measurement state')
display(get(cIN,'State'));
if ~isempty(cIN.ModelType), disp(sprintf('\tModel type: %s',cIN.ModelType)); end
if ~isempty(cIN.ExtrType), disp(sprintf('\tExtraction type: %s',cIN.ExtrType)); end
disp('Model Data')
display(get(cIN,'Data'));


