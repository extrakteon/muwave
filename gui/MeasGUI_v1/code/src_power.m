function src_power(hsrc, power)
% set source power in dBm
cmdstr = sprintf('POWER %3.4f', power);
fprintf(hsrc,cmdstr);
cmdstr = sprintf('*OPC?');
fprintf(hsrc,cmdstr);
fscanf(hsrc);