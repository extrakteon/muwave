function T = period(wf)
%PERIOD - returns period of the waveform
%
%   
% $Header$
% $Author: e7koffe $
% $Date: 2009-01-13 11:05:46 +0100 (ti, 13 jan 2009) $
% $Revision: 96 $ 
% $Log$
%

N = length(wf.freq);
if N > 1
    T = 1./wf.freq(2);
else
    T = Inf;
end