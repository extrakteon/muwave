function handles = saveMDIF(swp, handles)
%SAVEMDIF Saves the current swp file as .mdif

    handles.SavePath = strrep(handles.SavePath, '*.mat', '');
    [file,path] = uiputfile({'*.mdif', 'MDIF files'},'Save measurement', handles.SavePath);
    
    file = strrep(file, '.mdif', '');
    
    
    if ~isequal(path, 0) 
        handles.SavePath = path;    
        gridname = '';

        if strcmp(get(handles.figure, 'Name'), 'MeasIV')

            if ~iscell(swp)
                swpCell = swpSplitter(swp, handles);
            else
                swpCell = swp;
            end

            for cellNumber = 1:length(swpCell)
                try gridname = swpCell{cellNumber}(1).Gridname; end
                gridNumber = cellNumber;
                try gridNumber = swpCell{cellNumber}(1).Gridnumber; end
                mdifFile = [file, '{', num2str(gridNumber), '}' gridname,'.mdif'];
                write_IV_mdif(swpCell{cellNumber}, [path, mdifFile], handles);
            end

        elseif strcmp(get(handles.figure, 'Name'), 'MeasSP')

            swpCell = swpSplitter(swp, handles);

            for cellNumber = 1:length(swpCell)
                try gridname = swpCell{cellNumber}(1).Gridname; end
                gridNumber = cellNumber;
                try gridNumber = swpCell{cellNumber}(1).Gridnumber; end         
                mdifFile = [file, '{', num2str(gridNumber), '}' gridname,'.mdif'];
                write_SPwithIV_mdif(swpCell{cellNumber}, [path, mdifFile], handles);
            end

        end
    
    end


end

