function src_frequency(hsrc, freq)
% set source power in Hz
cmdstr = sprintf('FREQ %3.4f', freq);
fprintf(hsrc,cmdstr);
