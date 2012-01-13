% GENERATE DEFAULT SETTINGS FILE
function SETUP = DEFAULT_SETTINGS()

% SOURCE SETTING
SETUP.FRQ = 1e9; % fundamental frequency in Hz
SETUP.PWR = -60; % power available from the source in dBm
SETUP.SAFEPWR = -60; % safe source power in dBm, -60 is ok

% IQ MODULATOR SETTINGS
SETUP.NUMMOD = 0; % Number of modulators
SETUP.TONE = [2 3 4 5]; % DC = 1, FUND = 2, 2nd = 3
% SETUP.MODULATORS = [1 2]; % Index of used modulators
SETUP.OPTIMSTEP = 0.01; % Delta step used in optimization, default 0.01
% start values of IQ modulators
SETUP.SV = [0.01 0.01; 0.01 0.01; 0.01 0.01; 0.01 0.01]; % row 1 = fundamental, row 2 = 2nd harmonic

% ATTENUATOR SETTINGS
SETUP.NUMATT = 0;
SETUP.VCSTART = [10 10 10 10]; % starting control voltages
SETUP.VCSTEP = 0.4; % vc step

% BIAS SETTINGS
SETUP.BIAS_SETTLE = 0.2; % Bias settling time, default 0.1

% NO AUTO MEASUREMENT AS DEFAULT
SETUP.AUTO = 0;

SETUP.MEASTYPE =[];

try
    save('data/DEFAULT.mat');
catch
end