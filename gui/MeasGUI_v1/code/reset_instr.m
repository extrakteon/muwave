function reset_instr(instr)

% turn off input power
fprintf(instr.hsrc,':POW:STAT 0');
src_power(instr.hsrc, -60);

% turn off-bias
set(instr.dc2, 'Output', 0);
set(instr.dc1, 'Output', 0);

% % unload LSNA
% unloadlibrary('lsnaapi');
% 
% % disconnect instrument
% disconnect(instr.dc2);
% disconnect(instr.dc1);
% 
% % instrument reset
% instrreset;