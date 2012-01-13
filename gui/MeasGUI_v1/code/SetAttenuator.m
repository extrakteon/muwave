function VC = SetAttenuator(ao,VC)
% function for writing control voltages to attenuator controller
% ao is the analog output controller and VC is a vector containing 
% the control voltages

% check if control voltages are within allowed range, 0 - 10V
% put to 10 V (maximum attenuation) if not
for Idx = 1:length(VC)
    if (VC(Idx) < 0) || (VC(Idx) > 10)
        VC(Idx) = 10;
        disp('Check Attenuator Settings!');
    end
end

% send control voltages to analog output controller
putsample(ao,VC);

