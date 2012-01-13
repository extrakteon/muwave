function handles = AddBias(handles, varargin)
    
    % An option is to set the desired region as the second argument.
    % This will update the grid

    % resave measurement info
    DC1 = handles.instr.measure_dc1;
    DC2 = handles.instr.measure_dc2;
    
    if DC1 && ~(str2double(get(handles.i1comp,'String')) > 0) 
        errordlg('The current compliance have to be nonzero');
        return;
    end
    
    if DC2 && ~(str2double(get(handles.i2comp,'String')) > 0)
        errordlg('The current compliance have to be nonzero');
        return;
    end
    
    % Checks if an addition or an update is made
    UPDATING = 0;
    if ~isempty(varargin) && isnumeric(varargin{:})
        UPDATING = 1;
        region = varargin{:};
    else    
        region = handles.num_regions + 1;
        if DC1 || DC2
            handles.num_regions = handles.num_regions + 1;
        end
        set(handles.buttonDelete, 'Enable', 'on');
    end
    
    
    set(handles.buttonUpdate, 'Enable', 'on');
    set(handles.popupGrids, 'Enable', 'on');

    % Read out data from "Bias condition"
    if DC1
        v11 = get(handles.v1start,'String');
        v12 = get(handles.v1stop,'String');
        v13 = get(handles.v1step,'String');

        % get bias vector
        if strcmp(v11,v12) || strcmp(v13,'0') % check if constant or 0 step
            v1 = str2double(v11);
        else
            v1 = str2double(v11):str2double(v13):str2double(v12);
        end

        % read out current and power compliance
        i1 = str2double(get(handles.i1comp,'String'));
        p1 = str2double(get(handles.p1comp,'String'));

        

        % store bias info
        handles.bias.v1{region} = v1;
        handles.bias.i1{region} = i1;
        handles.bias.p1{region} = p1;
        
        
        
        
 
    end

    if DC2
        v21 = get(handles.v2start,'String');
        v22 = get(handles.v2stop,'String');
        v23 = get(handles.v2step,'String');

        % get bias vector
        if strcmp(v21,v22) || strcmp(v23,'0') % check if constant or 0 step
            v2 = str2double(v21);
        else
            v2 = str2double(v21):str2double(v23):str2double(v22);
        end 

        % read out current and power compliance
        i2 = str2double(get(handles.i2comp,'String'));
        p2 = str2double(get(handles.p2comp,'String'));

        

        % store bias info
        handles.bias.v2{region} = v2;
        handles.bias.i2{region} = i2;
        handles.bias.p2{region} = p2;
    end

    

    
    
    
    if ~strcmp(get(handles.editGridname, 'String'), '[Grid name]')
        regionName = strtrim(get(handles.editGridname, 'String'));
    else
        regionName = '';
    end

    handles.bias.name{region} = regionName;
    


    
    
    % update list in "Measurement regions"
    oldbias = handles.numBIAS; % get old number of bias points

    if DC1 && DC2
        % get bias grid

        BIASPoints = GetBIAS(handles);


        V1 = BIASPoints.V1; 
        V2 = BIASPoints.V2;
        I1 = BIASPoints.I1; 
        I2 = BIASPoints.I2;
        
        AllPoints = [V1, V2, I1, I2];

        if get(handles.removeDuplicates, 'Value')
            AllPoints = unique(AllPoints, 'rows');
        end

        % Sort by V1 if selected, else V2
        if get(handles.RadioV1, 'Value')
            AllPoints = sortrows(AllPoints, [1 2 3 4]);
        else
            AllPoints = sortrows(AllPoints, [2 1 3 4]);
        end

        V1 = AllPoints(:, 1);
        V2 = AllPoints(:, 2);
        I1 = AllPoints(:, 3);
        I2 = AllPoints(:, 4);
        
        totalBias = length(V1);

        bIdx = 1:totalBias;

        % generate new list
        for ix = 1:totalBias  
            write_str{bIdx(ix)} = sprintf('%d: %3.2f | %3.2f (%s | %s)', bIdx(ix), V1(ix), V2(ix), convertToPrefix(I1(ix), 'A'), convertToPrefix(I2(ix), 'A'));
        end

        set(handles.biasgrid,'String',write_str); % write list
        set(handles.biasgrid,'Value',totalBias); % change selected region  

    
    
    
    elseif DC1 && ~DC2

        
        BIASPoints = GetBIAS(handles); 



        V1 = BIASPoints.V1;
        I1 = BIASPoints.I1;

        
        AllPoints = [V1, I1];

        if get(handles.removeDuplicates, 'Value')
            AllPoints = unique(AllPoints, 'rows');            
        end
        
        AllPoints = sortrows(AllPoints);
        
        V1 = AllPoints(:, 1);
        I1 = AllPoints(:, 2);
        
        totalBias = length(V1);

        bIdx = 1:totalBias;

        % generate new list
        for ix = 1:length(bIdx)
            write_str{bIdx(ix)} = sprintf('%d: %3.2f | (%s |)', bIdx(ix), V1(ix), convertToPrefix(I1(ix), 'A'));
        end

        set(handles.biasgrid,'String',write_str); % write list
        set(handles.biasgrid,'Value',totalBias); % change selected region

    elseif ~DC1 && DC2
       
        BIASPoints = GetBIAS(handles); 

            V2 = BIASPoints.V2;
            I2 = BIASPoints.I2;

        AllPoints = [V2, I2];


        if get(handles.removeDuplicates, 'Value')
            AllPoints = unique(AllPoints, 'rows');            
        end
        
        AllPoints = sortrows(AllPoints);
   
        V2 = AllPoints(:, 1);
        I2 = AllPoints(:, 2);
        
        totalBias = length(V2);

        bIdx = 1:totalBias;  

        % generate new list
        for ix = 1:length(bIdx)
            write_str{bIdx(ix)} = sprintf('%d:  | %3.2f (| %s)', bIdx(ix), V2(ix), convertToPrefix(I2(ix), 'A'));
        end

        set(handles.biasgrid,'String',write_str); % write list
        set(handles.biasgrid,'Value',totalBias); % change selected region
    end


    % update number of bias points
    %handles.numBIAS = newbias + oldbias;
    handles.numBIAS = totalBias;



    try
        handles.numMEAS = handles.numBIAS;

        % update counter text
        ctext = sprintf('Point 0 out of %s',num2str(handles.numBIAS));
        set(handles.countertext,'String',ctext);
    end
    
    
    % Updates the grid listbox and the popmenu
    for reg = 1:handles.num_regions
        gridList{reg} =   ['(' num2str(reg) ') ' handles.bias.name{reg}];
    end
    set(handles.popupGrids, 'String', gridList(:));
    set(handles.popupGrids, 'Value', region);
    handles = writeBiasList(handles, region);



end

