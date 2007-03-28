function display(cIN)
% Method to display the properties of a measSP object.

% $Header$
% $Author: kristoffer $
% $Date: 2003-06-17 14:17:51 +0200 (Tue, 17 Jun 2003) $
% $Revision: 2 $ 
% $Log$
% Revision 1.1  2003/06/17 12:17:53  kristoffer
% Initial revision
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


