function swp = MeasureAnalyzer4156(handles, region, swpPrior)
%MEASUREANALYZER4156 Excecutes a measurement done by the DC4156



%% Initialize instruments
% instrreset;
% g_iv = gpib('ni', 0, 1);
% instr.iv = icdevice('agilent_4156_analyzer.mdd', g_iv);
% connect(instr.iv);

errMsg = 'Initialization failed!';

instr = handles.instr;
DC1 = instr.measure_dc1;
DC2 = instr.measure_dc2;


var = get(instr.iv,'VAR');
smu = get(instr.iv, 'SMU');

if DC1
    V1SMU = instr.smu1;
end

if DC2
    V2SMU = instr.smu2;
end

% Set the primary and secondary sweep variable
if DC1 && DC2
    if get(handles.RadioV1, 'Value')
        primaryNumber = 1;
        secondaryNumber = 2;
        V1Var = 'Var2';
        V2Var = 'Var1';
    else
        primaryNumber = 2;
        secondaryNumber = 1;
        V1Var = 'Var1';
        V2Var = 'Var2';
    end
    
    set(smu(V1SMU),'VoltageName','V1');
    set(smu(V1SMU),'CurrentName','I1');
    set(smu(V1SMU),'Mode','Voltage');
    set(smu(V1SMU),'Function', V1Var);

    set(smu(V2SMU),'VoltageName','V2');
    set(smu(V2SMU),'CurrentName','I2');
    set(smu(V2SMU),'Mode','Voltage');
    set(smu(V2SMU),'Function', V2Var);
    
elseif DC1 && ~DC2

    set(smu(V1SMU),'VoltageName','V1');
    set(smu(V1SMU),'CurrentName','I1');
    set(smu(V1SMU),'Mode','Voltage');
    set(smu(V1SMU),'Function', 'Var1');
    
    primaryNumber   = 0;
    secondaryNumber = 1;
    
elseif ~DC1 && DC2

    set(smu(V2SMU),'VoltageName','V2');
    set(smu(V2SMU),'CurrentName','I2');
    set(smu(V2SMU),'Mode','Voltage');
    set(smu(V2SMU),'Function', 'Var1');
    
    primaryNumber   = 0;
    secondaryNumber = 2;    
end


%% obtain the setup values

errMsg = 'Obtaining of setup values failed!';


bias = handles.bias;


if DC1   
    try
        v1Bias = bias.v1{region};
        
        v1Start = v1Bias(1);
        v1Step = median(diff(v1Bias(:)));
        v1Stop = v1Bias(end);
        v1Points = length(v1Bias); 
        i1Compliance = bias.i1{region};
    catch
        errordlg('The V1 values could not be intepreted');
        return;
    end
end


if DC2
    try
        v2Bias = bias.v2{region};
        
        v2Start = v2Bias(1);
        v2Step = median(diff(v2Bias(:)));
        v2Stop = v2Bias(end);
        v2Points = length(v2Bias); 
        i2Compliance = bias.i2{region};
    catch
        errordlg('The V2 values could not be intepreted');
        return;
    end
end


%% setup sweep
errMsg = 'Sweep setup failed!';

% If only one SMU is to be used only the secondary (inner) sweep will be
% managed


if DC1 && DC2

    VPRIMARY.START = eval(['v' num2str(primaryNumber) 'Start']);
    VPRIMARY.STEP = eval(['v' num2str(primaryNumber) 'Step']);
    VPRIMARY.POINTS = eval(['v' num2str(primaryNumber) 'Points']);
    IPRIMARY.COMPLIANCE =  eval(['i' num2str(primaryNumber) 'Compliance']);

end

VSEC.START = eval(['v' num2str(secondaryNumber) 'Start']); 
VSEC.STEP = eval(['v' num2str(secondaryNumber) 'Step']);
VSEC.STOP = eval(['v' num2str(secondaryNumber) 'Stop']);
ISEC.COMPLIANCE = eval(['i' num2str(secondaryNumber) 'Compliance']); 




%% Measure
try
    
    errMsg = 'Measurement failed!';
    
    if DC1 && DC2
        set(var(2), 'Start', VPRIMARY.START);
        set(var(2), 'Step', VPRIMARY.STEP);
        set(var(2), 'Points', VPRIMARY.POINTS);
        set(var(2), 'Compliance', IPRIMARY.COMPLIANCE);
    end
    
    set(var(1), 'Start', VSEC.START);
    set(var(1), 'Stop', VSEC.STOP); 
    set(var(1), 'Step', VSEC.STEP);
    set(var(1), 'Compliance', ISEC.COMPLIANCE);

    set(instr.iv, 'XName', ['V' num2str(secondaryNumber)]);
    
    set(instr.iv, 'Y1Name', ['I' num2str(secondaryNumber)]);

    if primaryNumber
        set(instr.iv, 'Y2Name', ['I' num2str(primaryNumber)]);
    end
    

    
    MEAS = invoke(instr.iv, 'Measure');
    
    errMsg = 'Conversion to meassweep object failed!';
    
    if DC1
        v1 = v1Bias;
    end
    
    if DC2
        v2 = v2Bias;
    end
    
    if DC1 && DC2
        [V1 V2] = meshgrid(v1, v2);       
        V1 = V1(:); 
        V2 = V2(:);
    elseif DC1 && ~DC2
        V1 = v1(:);
    elseif ~DC1 && DC2
        V2 = v2(:);
    end
    
    if DC1
        I1Points = i1Compliance*ones(size(V1, 1), 1);
    end
    if DC2
        I2Points = i2Compliance*ones(size(V2, 1), 1);
    end

    if DC1 && DC2
        
        AllPoints = [V1, V2, I1Points, I2Points];

        if get(handles.RadioV1, 'Value')
            AllPoints = sortrows(AllPoints, [1 2 3 4]);
        else
            AllPoints = sortrows(AllPoints, [2 1 3 4]);
        end
        
        BIAS.V1 = AllPoints(:, 1);
        BIAS.V2 = AllPoints(:, 2);
        BIAS.I1 = AllPoints(:, 3);
        BIAS.I2 = AllPoints(:, 4);
        
        NUMPOINTS = length(MEAS.V1);
        
    elseif DC1 && ~DC2
        
        AllPoints = [V1, I1Points];
        
        BIAS.V1 = AllPoints(:, 1);
        BIAS.I1 = AllPoints(:, 2);
        
        NUMPOINTS = length(MEAS.V1);
        
    elseif ~DC1 && DC2
        
        AllPoints = [V2, I2Points];  
        
        BIAS.V2 = AllPoints(:, 1);
        BIAS.I2 = AllPoints(:, 2);
        
        NUMPOINTS = length(MEAS.V2);
        
    end
    
       
    
    if isempty(swpPrior)
        swp = meassweep;
    end
    
    for Idx = 1:NUMPOINTS 
        sp = meassp;
        measmnt = get(sp, 'measmnt');
        measmnt = addprop(measmnt, 'Date', datestr(now));
        sp = set(sp, 'measmnt', measmnt);
        measstate = get(sp, 'measstate');
        if DC1
            measstate = addprop(measstate, 'V1', MEAS.V1(Idx));
            measstate = addprop(measstate, 'V1_SET', BIAS.V1(Idx));
            measstate = addprop(measstate, 'I1', MEAS.I1(Idx));
            measstate = addprop(measstate, 'I1_SET', BIAS.I1(Idx));
        end
        if DC2
            measstate = addprop(measstate, 'V2', MEAS.V2(Idx));
            measstate = addprop(measstate, 'V2_SET', BIAS.V2(Idx));
            measstate = addprop(measstate, 'I2', MEAS.I2(Idx));
            measstate = addprop(measstate, 'I2_SET', BIAS.I2(Idx));
        end
        measstate = addprop(measstate, 'Index', Idx);
        measstate = addprop(measstate, 'Gridnumber', region);
        measstate = addprop(measstate, 'Gridname', handles.bias.name{region});
        sp = set(sp, 'measstate', measstate);
        swp = add(swp, sp);
    end



catch
    errordlg(errMsg);
    swp = [];
    return;
end     
    

end

