function valid=isvalid_type(str)
% $Header$
% $Author: $
% $Date: $
% $Revision: $ 
% $Log$
%
if ischar(str) & (sum(strcmp(str,{'AB','VI'})))
	valid = 1;
else
   valid = 0;
   error('WAVEFORM: Invalid type. Should be either of: AB,VI.');
end
