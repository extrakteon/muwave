function handles = saveCSV(swp, handles)
%SAVECSV This function takes an swp object and write a csv file of it



    handles.SavePath = strrep(handles.SavePath, '*.mat', '');
    [file,path] = uiputfile({'*.csv', 'CSV files'},'Save measurement', handles.SavePath);
    
    
    
    if ~isequal(path, 0) 
        
        completePath = [path file];
        
        CSVmatrix = [];
        ColNames = '%%The columns are as follow: ';
        
        try CSVmatrix = swp.V1';
            CSVmatrix = [CSVmatrix, swp.I1'];
            ColNames = [ColNames, 'V1, I1, '];
        end
        
        try CSVmatrix = [CSVmatrix, swp.V2'];
            CSVmatrix = [CSVmatrix, swp.I2'];
            ColNames = [ColNames, 'V2, I2'];
        end
       
        csvwrite(completePath, CSVmatrix);
        
        fID = fopen(completePath, 'a');
        fprintf(fID, ['\r' ColNames]);
        fclose(fID);        
        
    end

end

