function valid=isvalid_type(str)
% $Header$
% $Author: koffe $
% $Date: 2009-01-13 11:05:46 +0100 (ti, 13 jan 2009) $
% $Revision: 96 $ 
% $Log$
%
if ischar(str) & (sum(strcmp(str,{'AB','VI'})))
	valid = 1;
else
   valid = 0;
   error('WAVEFORM: Invalid type. Should be either of: AB,VI.');
end
