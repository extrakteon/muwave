function SaveSetup(handles, MEAS)

    try 
        % save constants
        DATA.NUM_BIAS = handles.numBIAS;
        DATA.NUM_GL = handles.numGL;
        DATA.NUM_MEAS = handles.numMEAS;
        DATA.RADIOV1_SELECTED = get(handles.RadioV1, 'Value');
        DATA.REMOVE_DUP_SELECTED = get(handles.removeDuplicates, 'Value');

        % save bias
        DATA.BIASGRID = get(handles.biasgrid,'String'); % read bias list
        DATA.NUM_REGIONS = handles.num_regions;
        DATA.BIAS = handles.bias; % save bias points
        
        
        % save lsna specific settings
        if strcmp(MEAS,'LSNA')
            % save power
            DATA.PSTART = get(handles.Pstart,'String');
            DATA.PSTOP = get(handles.Pstop,'String');
            DATA.PSTEP = get(handles.Pstep,'String');

            % save GL
            DATA.NUMMOD = handles.SETUP.NUMMOD;
            DATA.GL = handles.GL;
            if DATA.NUMMOD == 2
                DATA.GL2 = handles.GL2;
            end
        end

        % save configuration type
        DATA.MEAS = MEAS;

        % save the measurement
        [file,path] = uiputfile('setup/*.mat','Save setup');
        if ~isequal(path, 0)
            save(fullfile(path,file), 'DATA');
        end
    catch
        errordlg('You must add a grid before saving setup');
    end