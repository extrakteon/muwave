function revsp = rev2port(sp)
% revsp = rev2port(sp)
% purpose: to reverse port directions of a 2-port

if sp.ports == 2
    revsp = sp;
    % reverse port directions:
    revsp.S11 = sp.S22;
    revsp.S21 = sp.S12;
    revsp.S12 = sp.S21;
    revsp.S22 = sp.S11;
else
    error('REV2PORT: Only 2-ports may be reversed.');
end

