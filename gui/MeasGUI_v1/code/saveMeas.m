function handles = saveMeas(swp, handles)
%SAVEMEAS Takes an swp, a file name and a path and saves it

    global FILENAME;

    % disable stop button
    set(handles.stop,'Enable','Off');

   
    if handles.SETUP.AUTO
        try
            save(handles.SETUP.FILENAME, 'swp');
        end
    else
        
        
        handles.SavePath = strrep(handles.SavePath, '*.mat', '');
        [file,path] = uiputfile({'*.mat', 'MAT filetype'},'Save measurement', handles.SavePath);
        FILENAME = file; 

        if ~isequal(path, 0) 
            handles.SavePath = path;
            save(fullfile(path,file), 'swp');
        end

    end
    
    set(handles.measure,'Enable','On'); % enable measure button


end
