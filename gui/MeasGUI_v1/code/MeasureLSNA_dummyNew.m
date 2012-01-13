function [swp data] = MeasureLSNA_dummyNew(handles)
global MEAS_CANCEL;
% swp
demoswp = handles.swp;

% % resave SETUP 
% SETUP = handles.SETUP;

% Input power
PIN = handles.PIN;
% Bias
BIAS = handles.BIAS;
% Gl
GL = handles.GL;

% number of bias points
NBIAS = length(BIAS.V1);

% number of input powers
NPWR = length(PIN);

% number of gammaL
[tmp NGL] = size(GL);

% number of measurements
NMEAS = NBIAS*NPWR*NGL;
NDONE = 0;

% keep track of execution time
t_elapsed = 0;

% turn on timer
tic;

% get frequencies
freq = demoswp.freq;

% create meassweep object
swp = meassweep;

% loop over bias, power impedances
for bIdx = 1:NBIAS
    % Set bias
%     pause(0.1);    
    
    for pIdx = 1:NPWR            
        % Set power
%         pause(0.1); 
        
        for gIdx = 1:NGL
            % counter
            NDONE = NDONE + 1;          
                  
            %----------MEASURE----------            
            % read out LSNA data
            V1 = demoswp.v1(NDONE,:);
            I1 = demoswp.i1(NDONE,:);
            V2 = demoswp.v2(NDONE,:);
            I2 = demoswp.i2(NDONE,:);
            
            % save waveform measurement
            wf = measwf(waveform([V1; I1; V2; I2],freq,'VI'));
            swp = add(swp, wf);            

            % save a backup copy of the measurement
            save('data/backup.mat','swp'); 

            % update plots and measurement data in display window
            % update bias boxes
            set(handles.mv1,'String',num2str(round(wf.V1dc.*100)/100));
            set(handles.mi1,'String',num2str(round(wf.I1dc.*1e3.*100)/100));
            set(handles.mv2,'String',num2str(round(wf.V2dc.*100)/100));
            set(handles.mi2,'String',num2str(round(wf.I2dc.*100)/100));

            % calculate power and gain
            data.Pin(NDONE) = 10*log10((abs(wf.A1fc).^2./100))+30;
            data.Pin_del(NDONE) = 10*log10(((abs(wf.A1fc).^2-abs(wf.B1fc).^2)./100))+30;
            data.Pout(NDONE) = 10*log10(((abs(wf.B2fc).^2-abs(wf.A2fc).^2)./100))+30;
            data.Gt(NDONE) = data.Pout(NDONE) - data.Pin(NDONE);
            data.Gp(NDONE) = data.Pout(NDONE) - data.Pin_del(NDONE);
            data.Deff(NDONE) = 100.*10.^((data.Pout(NDONE)-30)./10)./(wf.V2dc.*wf.I2dc);
            
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
            
%             % waveform measurement
%             axes(handles.ax1);
%             plot(swp(NDONE).v1,swp(NDONE).i1,'-k','LineWidth',2);
%             xlabel('V_1 [V]');
%             ylabel('I_1 [A]');            
%             axes(handles.ax2);            
%             plot(swp(NDONE).v2,swp(NDONE).i2,'-k','LineWidth',2);
%             xlabel('V_2 [V]');
%             ylabel('I_2 [A]');
            
            % update smithchart
            data.GL(NDONE) = wf.A2fc./wf.B2fc;
            axes(handles.smith);
            h = get(handles.smith, 'Children');
            temp = get(h(1), 'UserData');
            set(h(1),'UserData',[temp NDONE]);
            temp = get(h(1), 'XData');
            set(h(1),'XData',[temp real(data.GL(NDONE))]);
            temp = get(h(1), 'YData');
            set(h(1),'YData',[temp imag(data.GL(NDONE))]);            
            
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
        if MEAS_CANCEL
            disp('STOP PWR');
            break
        end        
    end  
    if MEAS_CANCEL
        disp('STOP BIAS');
        break
    end    
end