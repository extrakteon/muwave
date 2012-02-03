function transpose_touchstone(fname)
% TRANSPOSE_TOUCHSTONE:
% Transposes ports in touchstone files, i.e. s11->s22 etc
% Overwrites input file, so only use ONCE! 

% $Header$
% $Author: koffe $
% $Date: 2009-01-13 11:05:46 +0100 (ti, 13 jan 2009) $
% $Revision: 96 $ 
% $Log$
% Revision 1.2  2005/04/27 21:41:32  fager
% * Changed from measSP to meassp.
%
% Revision 1.1  2004/10/07 08:30:10  ferndahl
% Initial version...
%

SPin = read_touchstone(meassp,fname);

SPout = SPin;
SPout.S11 = SPin.S22;
SPout.S22 = SPin.S11;
SPout.S12 = SPin.S21;
SPout.S21 = SPin.S12;

write_touchstone(SPout,fname)







