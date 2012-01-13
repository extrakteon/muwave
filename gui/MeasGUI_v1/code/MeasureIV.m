function swp = MeasureIV(instr,BIAS,handles)
    global MEAS_CANCEL; %global variable for canceling measurement

    % resave measurement info
    DC1 = handles.instr.measure_dc1;
    DC2 = handles.instr.measure_dc2;

    % Bias settling time
    BIAS_SETTLE = handles.SETUP.BIAS_SETTLE;

    % number of bias points
    NMEAS = BIAS.NUMPOINTS;
    NDONE = 0;

    % keep track of execution time
    t_elapsed = 0;
    % turn on timer
    tic;

    % init data storage
    swp = meassweep;

    for Idx = 1:NMEAS


        if strcmp(handles.SETUP.MEASTYPE, 'DEMO')

            % Measure dummy DC-bias
            if DC1
                MEAS.I1 = BIAS.V1(Idx)/(200);
                MEAS.V1 = BIAS.V1(Idx);
            end

            if DC2
                MEAS.I2 = BIAS.V2(Idx)/(200);
                MEAS.V2 = BIAS.V2(Idx);
            end


        else



            % set bias point and turn on bias
            if DC1
                set(instr.dc1, 'Voltage', BIAS.V1(Idx));
                set(instr.dc1, 'Current', BIAS.I1(Idx));
                set(instr.dc1, 'Output', 1);
            end
            if DC2
                set(instr.dc2, 'Voltage', BIAS.V2(Idx));
                set(instr.dc2, 'Current', BIAS.I2(Idx));
                set(instr.dc2, 'Output', 1);
            end

            % Pause
            pause(BIAS_SETTLE);

            % measure DC-bias
            if DC1
                MEAS.I1 = invoke(instr.i1, 'MeasCurrent');
                MEAS.V1 = invoke(instr.v1, 'MeasVoltage');
            end

            if DC2
                MEAS.I2 = invoke(instr.i2, 'MeasCurrent');
                MEAS.V2 = invoke(instr.v2, 'MeasVoltage');
            end

            % turn off-bias
            if DC2
                set(instr.dc2, 'Output', 0);
            end
            if DC1
                set(instr.dc1, 'Output', 0);
            end

        end


        % counter
        NDONE = NDONE + 1;

        % save data
        sp = meassp;
        measmnt = get(sp, 'measmnt');
        measmnt = addprop(measmnt, 'Date', datestr(now));
        sp = set(sp, 'measmnt', measmnt);
        measstate = get(sp, 'measstate');
        if DC1
            measstate = addprop(measstate, 'V1', MEAS.V1);
            measstate = addprop(measstate, 'V1_SET', BIAS.V1(Idx));
            measstate = addprop(measstate, 'I1', MEAS.I1);
            measstate = addprop(measstate, 'I1_SET', BIAS.I1(Idx));
        end
        if DC2
            measstate = addprop(measstate, 'V2', MEAS.V2);
            measstate = addprop(measstate, 'V2_SET', BIAS.V2(Idx));
            measstate = addprop(measstate, 'I2', MEAS.I2);
            measstate = addprop(measstate, 'I2_SET', BIAS.I2(Idx));
        end
        measstate = addprop(measstate, 'Index', NDONE);
        measstate = addprop(measstate, 'Gridnumber', BIAS.REGION(Idx));
        measstate = addprop(measstate, 'Gridname', handles.bias.name{BIAS.REGION(Idx)});
        sp = set(sp, 'measstate', measstate);
        swp = add(swp, sp);
        save('data/backup.mat','swp'); % save a backup copy of the measurement


        % update plots and data boxes
        if DC1
            axes(handles.ax1);
            plot(swp.V1,swp.I1,'.');
            set(handles.mv1,'String',num2str(round(MEAS.V1.*100)/100));
            set(handles.mi1,'String',num2str(round(MEAS.I1.*1e3.*100)/100));
        end
        if DC2
            axes(handles.ax2);
            plot(swp.V2,swp.I2,'.');
            set(handles.mv2,'String',num2str(round(MEAS.V2.*100)/100));
            set(handles.mi2,'String',num2str(round(MEAS.I2.*100)/100));
        end

        % calculate estimated time for finishing measurement
        t_elapsed = toc;
        t_remain = (NMEAS - NDONE) * t_elapsed/NDONE;
        [days, hours, min, sec] = elapsed2date(round(t_remain));
        donestr = sprintf('Point %d out of %d', NDONE, NMEAS);
        dstr = sprintf('Finnished in %d h, %d min, %d s.', hours, min, sec);
        set(handles.countertext,'String',donestr);
        set(handles.timetext,'String',dstr);


        if MEAS_CANCEL
            break;
        end
    end

    if DC1
        axes(handles.ax1);
        xlabel('V_1');
        ylabel('I_1');
    end
    if DC2
        axes(handles.ax2);
        xlabel('V_2');
        ylabel('I_2');
    end