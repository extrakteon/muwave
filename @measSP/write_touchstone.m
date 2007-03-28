function write_touchstone(cIN,write_filename)
% Saves a measSP object as a Touchstone file
% Created 02-01-06 by Christian Fager
%
% Revision history.
% v1.0 -- Date 02-01-06
% Created

ports=get(cIN.Data,'ports');
extix=findstr('.',write_filename);
if isempty(extix)	% No extension specified, use S-parameter representation
    ext=['.S',int2str(ports),'P'];
    write_filename=[write_filename,ext];
end

f_ID=fopen(write_filename,'wt');
if f_ID~=-1
    TempStr=['! Created: ',datestr(now)];
    fprintf(f_ID,'%s\n',TempStr);
    
    TempStr=['! File origin: ',getOrigin(cIN)];
    fprintf(f_ID,'%s\n',TempStr);
    
    if ~isempty(getOperator(cIN))
        TempStr=['! Operator: ',getOperator(cIN)];
        fprintf(f_ID,'%s\n',TempStr);
    end
    
    if ~isempty(getInfo(cIN))
        TempStr=['! Info: ',getInfo(cIN)];
        fprintf(f_ID,'%s\n',TempStr);
    end
    
    
    TempStr=['! Gate Length [m]: ',num2str(get(cIN,'GateLength'))];
    fprintf(f_ID,'%s\n',TempStr);
    
    TempStr=['! Gate Width [m]: ',num2str(get(cIN,'GateWidth'))];
    fprintf(f_ID,'%s\n',TempStr);
    
    TempStr=['! Gate Voltage [V]: ',num2str(get(cIN,'Vgsq'))];
    fprintf(f_ID,'%s\n',TempStr);
    
    TempStr=['! Drain Voltage [V]: ',num2str(get(cIN,'Vdsq'))];
    fprintf(f_ID,'%s\n',TempStr);
    
    TempStr=['! Gate Current [A]: ',num2str(get(cIN,'Igsq'))];
    fprintf(f_ID,'%s\n',TempStr);
    
    TempStr=['! Drain Current [A]: ',num2str(get(cIN,'Idsq'))];
    fprintf(f_ID,'%s\n',TempStr);
    
    if ~isempty(get(cIN,'Temp'))
        TempStr=['! Temperature: ',num2str(get(cIN,'Temp'))];
        fprintf(f_ID,'%s\n',TempStr);
    end

    if ~isempty(get(cIN,'PulseWidth'))
        TempStr=['! Pulsewidth [s]: ',num2str(get(cIN,'PulseWidth'))];
        fprintf(f_ID,'%s\n',TempStr);
    end
    
    if ~isempty(get(cIN,'Period'))
        TempStr=['! Period [s]: ',num2str(get(cIN,'Period'))];
        fprintf(f_ID,'%s\n',TempStr);
    end

    fprintf(f_ID,'\n');
    
    data_mtrx=1e-9*freq(cIN).';
    for col=1:ports
        for row=1:ports
            temp=get(cIN.Data,['S',int2str(row),int2str(col)]);
            data_mtrx=cat(2,data_mtrx,[real(temp),imag(temp)]);
        end
    end
    
    reference=get(cIN.Data,'reference');
    type=get(cIN.Data,'type');	
    
    TempStr=['# GHZ S RI R ',int2str(reference)];
    fprintf(f_ID,'%s\n\n',TempStr);
    
    scanstr=['%e',repmat([' %e %e'],[1,ports^2]),'\n'];
    fprintf(f_ID,scanstr,data_mtrx.');
    
    fclose(f_ID);
else
    error('Error in opening file for writing');
end