function swp = deembedd_lsna_data(swp,L,C)
w = 2*pi*swp.freq;
Vz = swp.V1;
Iz = swp.I1+swp.I2;
Ir = Iz-Vz.*(j*w.*C);
Vr = Vz - j.*w.*L.*Ir;
% create meassweep object
nswp = meassweep;
for Idx = 1:length(swp)
    V1 = Vr(Idx,:);
    V1(1) = 0;
    I1 = Ir(Idx,:);
    I1(1) = 0;
    V2 = V1;
    I2 = zeros(size(I1));
    freq = swp(Idx).freq;
    % save waveform measurement
    wf = measwf(waveform([V1; I1; V2; I2],freq,'VI'));
    nswp = add(nswp, wf);
end
swp = nswp;