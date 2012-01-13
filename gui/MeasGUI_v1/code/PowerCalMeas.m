function data = PowerCalMeas(SETUP, CAL, instr)
% number of measurements
NMEAS = length(CAL.VC);
NDONE = 0;

% keep track of execution time
t_elapsed = 0;

% turn on timer
tic;

% Show progressbar
h_wb = waitbar(0, 'Measurement about to start. Please wait.');

% set IQ modulator in 50 ohm
for Idx = 1:SETUP.NUMMOD
    SetIQRec(0, 0, instr.dio, Idx);
end

% get frequencies
data.freq = lsna_freq_list;

% set source
src_frequency(instr.hsrc, SETUP.FRQ);
src_power(instr.hsrc, SETUP.PWR);

% loop over measurements
for Idx = 1:NMEAS
    NDONE = NDONE + 1;
    % Set attenuators        
    vc = [CAL.VC(Idx) 10.*ones(1,SETUP.NUMATT-1)];
    data.VC(Idx) = CAL.VC(Idx);
    putsample(instr.ao,vc);
    pause(CAL.ATTSETTLE);

    % turn on source power
    fprintf(instr.hsrc,':POW:STAT 1');
      
    % Measure lsna
    lsna_measure;
            
    % store measurement data
    data.a1(NDONE,:) = lsna_read_data('a1');
            
    % Convert a and b waves to power
    data.Pin(NDONE) = 10.*log10(abs(data.a1(NDONE,SETUP.TONE(1))).^2/100) + 30;

    % save a backup copy of the measurement
    save('data/calbackup.mat','data'); 

    % calculate estimated time for finishing measurement
    t_elapsed = toc;
    t_remain = (NMEAS - NDONE) * t_elapsed/NDONE;
    [days, hours, min, sec] = elapsed2date(round(t_remain));
    dstr = sprintf('Measurement will finish in about:\n%d day(s), %d h, %d min, %d sec.', days, hours, min, sec);
    % show progressbar
    waitbar(NDONE/NMEAS, h_wb, dstr);
    
    % turn off source power
    fprintf(instr.hsrc,':POW:STAT 0');
    
    if data.Pin(NDONE) > CAL.MAXPWR
        break
    end
end

% turn off source power
fprintf(instr.hsrc,':POW:STAT 0');
src_power(instr.hsrc, SETUP.SAFEPWR);
    
% close progressbar
close(h_wb);