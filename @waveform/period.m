function T = period(wf)
%PERIOD - returns period of the waveform
%
%   
% $Header$
% $Author: $
% $Date: $
% $Revision: $ 
% $Log$
%

N = length(wf.freq);
if N > 1
    T = 1./wf.freq(2);
else
    T = Inf;
end