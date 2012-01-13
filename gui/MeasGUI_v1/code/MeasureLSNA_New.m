function [swp data] = MeasureLSNA_New(handles)
global MEAS_CANCEL;

% resave instruments 
instr = handles.instr;

% resave SETUP 
SETUP = handles.SETUP;

% resave meastype
MEASTYPE = SETUP.MEASTYPE; 

switch MEASTYPE
    case 'PWRSWP'
        ACTIVELP = false; % ActiveLP measurement
        USEATT = false; % Use attenuators
    case 'PWRSWP_ATT'
        ACTIVELP = false; % ActiveLP measurement
        USEATT = true; % Use attenuators
    case 'ACTIVELP'
        ACTIVELP = true; % ActiveLP measurement
        USEATT = false; % Use attenuators
    case 'ACTIVELP_ATT'
        ACTIVELP = true; % ActiveLP measurement
        USEATT = true; % Use attenuators
end
% Optimization, check if activeLP measurement
if ACTIVELP
    Options = optimset('MaxIter',30,'Display','iter','TolFun',1e-3,...
        'TolX', 1e-5, 'Jacobian','on');
    LB = [-1 -1]; % lower boundry
    UB =  [1 1]; % upper boundry
    SV = SETUP.SV(1:SETUP.NUMMOD,:); % Start value for IQ modulators
end
% Attenuators, check if attenuator measurement
if USEATT
    VC = SETUP.VCSTART(1:SETUP.NUMATT); % start value of attenuators
end

% Input power
PIN = handles.PIN;
% number of input powers
NPWR = length(PIN);

% Bias
BIAS = handles.BIAS;
% number of bias points
NBIAS = BIAS.NUMPOINTS;

% Gl
if ACTIVELP
    GL = handles.GL;
    % number of gammaL
    [tmp NGL] = size(GL);    
else
    NGL = 1;
end

% number of measurements
NMEAS = NBIAS*NPWR*NGL;
NDONE = 0;

% keep track of execution time
t_elapsed = 0;

% turn on timer
tic;

if ACTIVELP
    % set IQ modulator in 50 ohm
    for Idx = 1:SETUP.NUMMOD
        SetIQRec(SV(Idx,1), SV(Idx,2), instr.dio, Idx);
    end
end

% get frequencies
freq = lsna_freq_list;

% set source frequency and power
src_frequency(instr.hsrc, SETUP.FRQ);
if USEATT
    src_power(instr.hsrc, SETUP.PWR);
else
    src_power(instr.hsrc, SETUP.SAFEPWR);
end

% create meassweep object
swp = meassweep;

% loop over bias, power impedances
for bIdx = 1:NBIAS
    
    % Set bias 1
    if instr.measure_dc1
        set(instr.dc1, 'Voltage', BIAS.V1(bIdx));
        set(instr.dc1, 'Current', BIAS.I1(bIdx));
        set(instr.dc1, 'Output', 1);
    end
    
    % Set bias 2
    if instr.measure_dc2
        set(instr.dc2, 'Voltage', BIAS.V2(bIdx));
        set(instr.dc2, 'Current', BIAS.I2(bIdx));
        set(instr.dc2, 'Output', 1);
    end

    % Pause
    pause(SETUP.BIAS_SETTLE);   
    
    for pIdx = 1:NPWR
        if USEATT
            % Set attenuators
            VCin = GetVC(PIN(pIdx),SETUP.PinFit);
            VC(1) = VCin;
%             putsample(instr.ao,VC);
            VC = SetAttenuator(instr.ao,VC);
        else
            src_power(instr.hsrc, PIN(pIdx));
        end
        
        % turn on source power
        fprintf(instr.hsrc,':POW:STAT 1');
        fprintf(instr.hsrc,'*OPC?');
        fscanf(instr.hsrc);
        
        % Pause
        pause(SETUP.BIAS_SETTLE);        
            
        if NGL > 1
            SV = SETUP.SV;
        end
        
        for gIdx = 1:NGL
            % counter
            NDONE = NDONE + 1;          
            
            if ACTIVELP
                % measure
                for mIdx = 1:SETUP.NUMMOD
                    Tone = SETUP.TONE(mIdx);
                    ModNum = mIdx;
                    Step = SETUP.OPTIMSTEP;
                    gl = GL(mIdx,gIdx); % get current GL
                    sv = SV(mIdx,:);
                    
                    % find GammaL
                    if SETUP.NUMATT < 2
                        [iq resnorm] = lsqnonlin(@(x)...
                            ErrFun(x,gl,Tone,instr.dio,ModNum,Step),sv,LB,UB,Options);
                    else
                        Err = true; 
                        while Err
                            [iq resnorm] = lsqnonlin(@(x)...
                                ErrFun(x,gl,Tone,instr.dio,ModNum,Step),sv,LB,UB,Options);
                            % Test if attenuators needs to be changed
                            if (sqrt(abs(iq(1)).^2 + abs(iq(2)).^2) > 0.9)
                                NEWVC = VC(ModNum+1) - SETUP.VCSTEP;
                                dstr = sprintf(...
                                    '|I + Q| > 0.9. Decrease attenuator%1.0f Vc from %4.2f to %4.2f? (Write N to stop measurement)'...
                                    ,(ModNum+1),VC(ModNum+1), NEWVC);
                                INDATA = input(dstr);
                                if isempty(INDATA)
                                    VC(ModNum+1) = NEWVC;
%                                     putsample(instr.ao,VC);
                                    VC = SetAttenuator(instr.ao,VC);
                                else
                                    MEAS_CANCEL = true;
                                end
                            elseif (sqrt(abs(iq(1)).^2 + abs(iq(2)).^2) < 0.1)
                                NEWVC = VC(ModNum+1) + SETUP.VCSTEP;
                                dstr = sprintf(...
                                    '|I + Q| < 0.1. Increase attenuator%1.0f Vc from %4.2f to %4.2f? (Write N to stop measurement)'...
                                    ,(ModNum+1),VC(ModNum+1), NEWVC);
                                INDATA = input(dstr);
                                if isempty(INDATA)
                                    VC(ModNum+1) = NEWVC;
%                                     putsample(instr.ao,VC);
                                    VC = SetAttenuator(instr.ao,VC);
                                else
                                    MEAS_CANCEL = true;
                                end
                            else % Optimization worked
                                Err = false;
                            end
                            
                            % check if stop
                            if MEAS_CANCEL
                                disp('STOP OPT');
                                break
                            end
                        end
                    end

                    % save I and Q
                    data.I(NDONE,mIdx) = round(2048 - iq(1).*2047);
                    data.Q(NDONE,mIdx) = round(2048 - iq(2).*2047);
                    data.Irec(NDONE,mIdx) = iq(1);
                    data.Qrec(NDONE,mIdx) = iq(2);
                    data.resnorm(NDONE,mIdx) = resnorm;
                    if USEATT
                        data.VC(NDONE,:) = VC;
                    end
                    SV(mIdx,:) = iq; % update start value

                    % set I and Q
                    SetIQRec(iq(1), iq(2), instr.dio, ModNum);
                    pause(0.1);
                    
                    % check if stop
                    if MEAS_CANCEL
                        disp('STOP MOD');
                        break
                    end
                end
            end
            
            %----------MEASURE---------- 
            % measure DC-bias
            if instr.measure_dc1
                V1dc = invoke(instr.v1, 'MeasVoltage');
                I1dc = invoke(instr.i1, 'MeasCurrent');
            else
                V1dc = 0;
                I1dc = 0;
            end
            if instr.measure_dc2
                V2dc = invoke(instr.v2, 'MeasVoltage');
                I2dc = invoke(instr.i2, 'MeasCurrent');
            else
                V2dc = 0;
                I2dc = 0;
            end
            
            % measure LSNA
            lsna_measure;            
            
            % read out LSNA data
            V1 = lsna_read_data('v1');
            I1 = lsna_read_data('i1');
            V2 = lsna_read_data('v2');
            I2 = lsna_read_data('i2');
            
            % set dc level
            V1(1) = V1dc;
            I1(1) = I1dc;
            V2(1) = V2dc;
            I2(1) = I2dc;

            % save waveform measurement
            wf = measwf(waveform([V1; I1; V2; I2],freq,'VI'));
            swp = add(swp, wf);

            % save a backup copy of the measurement
            save('data/backup.mat','swp'); 

            % update plots and measurement data in display window
            % update bias boxes
            if instr.measure_dc1
                set(handles.mv1,'String',num2str(round(wf.V1dc.*100)/100));
                set(handles.mi1,'String',num2str(round(wf.I1dc.*1e3.*100)/100));
            end
            if instr.measure_dc2
                set(handles.mv2,'String',num2str(round(wf.V2dc.*100)/100));
                set(handles.mi2,'String',num2str(round(wf.I2dc.*100)/100));
            end
            
            % calculate power and gain
            data.Pin(NDONE) = real(10*log10((abs(wf.A1fc).^2./100))+30);
            data.Pin_del(NDONE) = real(10*log10(((abs(wf.A1fc).^2-abs(wf.B1fc).^2)./100))+30);
            data.Pout(NDONE) = real(10*log10(((abs(wf.B2fc).^2-abs(wf.A2fc).^2)./100))+30);
            data.Gt(NDONE) = real(data.Pout(NDONE) - data.Pin(NDONE));
            data.Gp(NDONE) = real(data.Pout(NDONE) - data.Pin_del(NDONE));
            data.Deff(NDONE) = real(100.*10.^((data.Pout(NDONE)-30)./10)./(wf.V2dc.*wf.I2dc));
            
            % update power and gain boxes
            set(handles.mpout,'String',num2str(round(data.Pout(NDONE).*10)/10));
            set(handles.mgt,'String',num2str(round(data.Gt(NDONE).*10)/10));
            set(handles.mgp,'String',num2str(round(data.Gp(NDONE).*10)/10));
            set(handles.mdeff,'String',num2str(round(data.Deff(NDONE).*10)/10));
            
            % update plots
            % pin/pout
            axes(handles.ax3);
            plot(data.Pin,data.Pout,'.k','LineWidth',2);
            xlabel('P_I_N [dBm]');
            ylabel('P_O_U_T [dBm]');

            % pin/deff
            axes(handles.ax4);
            plot(data.Pin,data.Deff,'.k','LineWidth',2);
            xlabel('P_I_N [dBm]');
            ylabel('\eta [%]');
            
            % waveform measurement
            axes(handles.ax1);
            plot(wf.v1,wf.i1,'-k','LineWidth',2);
            xlabel('V_1 [V]');
            ylabel('I_1 [A]');            
            axes(handles.ax2);            
            plot(wf.v2,wf.i2,'-k','LineWidth',2);
            xlabel('V_2 [V]');
            ylabel('I_2 [A]');
            
            % update smithchart
            data.GL(NDONE) = wf.A2(SETUP.TONE(1))./wf.B2(SETUP.TONE(1));
            h = get(handles.smith, 'Children');
            temp = get(h(1), 'UserData');
            set(h(1),'UserData',[temp NDONE]);
            temp = get(h(1), 'XData');
            set(h(1),'XData',[temp real(data.GL(NDONE))]);
            temp = get(h(1), 'YData');
            set(h(1),'YData',[temp imag(data.GL(NDONE))]);
            if SETUP.NUMMOD == 2
                data.GL2(NDONE) = wf.A2(SETUP.TONE(2))./wf.B2(SETUP.TONE(2));
                temp = get(h(3), 'UserData');
                set(h(3),'UserData',[temp NDONE]);
                temp = get(h(3), 'XData');
                set(h(3),'XData',[temp real(data.GL2(NDONE))]);
                temp = get(h(3), 'YData');
                set(h(3),'YData',[temp imag(data.GL2(NDONE))]);
            end
            drawnow; % update axes            
            
            % calculate estimated time for finishing measurement
            t_elapsed = toc;
            t_remain = round((NMEAS - NDONE) * t_elapsed/NDONE);
            [days, hours, min, sec] = elapsed2date(round(t_remain));
            donestr = sprintf('Point %d out of %d', NDONE, NMEAS);
%             dstr = sprintf('Finnished in %s s.', num2str(t_remain));
            dstr = sprintf('Finnished in about: %d day(s), %d h, %d min, %d sec.', days, hours, min, sec);
            set(handles.countertext,'String',donestr);
            set(handles.timetext,'String',dstr);
            if MEAS_CANCEL
                disp('STOP GL');
                break
            end
        end
        % turn off source power
        fprintf(instr.hsrc,':POW:STAT 0');  
        fprintf(instr.hsrc,'*OPC?');
        fscanf(instr.hsrc);
        
        % check if stop
        if MEAS_CANCEL
            disp('STOP PWR');
            break
        end        
    end
    % turn off-bias
    if instr.measure_dc2
        set(instr.dc2, 'Output', 0);
    end
    if instr.measure_dc1
        set(instr.dc1, 'Output', 0);
    end
    
    % check if stop
    if MEAS_CANCEL
        disp('STOP BIAS');
        break
    end    
end

% Set source to safe level
src_power(instr.hsrc, SETUP.SAFEPWR);