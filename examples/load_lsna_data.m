function swp = load_lsna_data(loadfile,frqidx)
load(loadfile);
oswp=swp;
% create meassweep object
swp = meassweep;
for Idx = 1:length(oswp)
    V1 = oswp(Idx).V1(1:frqidx:end);
    I1 = oswp(Idx).I1(1:frqidx:end);
    V2 = oswp(Idx).V2(1:frqidx:end);
    I2 = oswp(Idx).I2(1:frqidx:end);
    freq = oswp(Idx).freq(1:frqidx:end);
    % save waveform measurement
    wf = measwf(waveform([V1; I1; V2; I2],freq,'VI'));
    swp = add(swp, wf);
end