function handles = deleteBias(handles, region)
%DELETEBIAS Deletes a single bias grid
    
    DC1 = handles.instr.measure_dc1;
    DC2 = handles.instr.measure_dc2;
    
    lastRegion = 0;
    % Remove the selected region
    if DC1
        handles.bias.v1(region) = [];
        handles.bias.i1(region) = [];
        handles.bias.p1(region) = [];
        if isempty(handles.bias.v1)
            lastRegion = 1;
        end
    end
    if DC2
        handles.bias.v2(region) = [];
        handles.bias.i2(region) = [];
        handles.bias.p2(region) = [];
        if isempty(handles.bias.v2)
            lastRegion = 1;
        end
    end
    
    handles.bias.name(region) = [];
    handles.num_regions = handles.num_regions - 1;
    
    
    % If this was the last region; Disable buttons and etc.
    % Else; Write out the end region as individual och write out the total 
    if lastRegion
        set(handles.biasgrid,'String','');
        set(handles.listboxIndividual,'String', '');
        set(handles.popupGrids, 'String', ' ');
        set(handles.popupGrids, 'Value', 1);
        
        set(handles.buttonDelete, 'Enable' , 'inactive');
        set(handles.popupGrids, 'Enable' , 'off');
        set(handles.buttonUpdate, 'Enable' , 'off');    
    else
        
        
        
        % Updates the grid listbox and the popmenu
        for reg = 1:handles.num_regions
            gridList{reg} =  ['(' num2str(reg) ') ' handles.bias.name{reg}];
        end
        
        set(handles.popupGrids, 'Value', handles.num_regions);
        set(handles.popupGrids, 'String', gridList(:));
        handles = changeBias(handles, handles.num_regions);
        
        
        
        BIAS = GetBIAS(handles);
        
        if DC1 && DC2
            
            AllPoints = [BIAS.V1, BIAS.V2, BIAS.I1, BIAS.I2];
            
            if get(handles.removeDuplicates, 'Value')
                AllPoints = unique(AllPoints, 'rows');
            end
            
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
            set(handles.biasgrid,'Value',totalBias);
            
            
        elseif DC1 && ~DC2
            
            AllPoints = [BIAS.V1, BIAS.I1];
            
            if get(handles.removeDuplicates, 'Value')
                AllPoints  = unique(AllPoints , 'rows');
            else
                AllPoints  = sortrows(AllPoints, [1 2]);
            end
            
            V1 = AllPoints(:, 1);
            I1 = AllPoints(:, 2);
            
            totalBias = length(V1);
            bIdx = 1:totalBias;

            % generate new list
            for ix = 1:length(bIdx)
                write_str{bIdx(ix)} = sprintf('%d: %3.2f | (%s |)', bIdx(ix), V1(ix), convertToPrefix(I1(ix), 'A'));
            end

            set(handles.biasgrid,'String',write_str); % write list
            set(handles.biasgrid,'Value',totalBias);
            
        elseif ~DC1 && DC2
            
            AllPoints = [BIAS.V2, BIAS.I2];
            
            if get(handles.removeDuplicates, 'Value')
                AllPoints  = unique(AllPoints , 'rows');
            else
                AllPoints  = sortrows(AllPoints, [1 2]);
            end
            
            V2 = AllPoints(:, 1);
            I2 = AllPoints(:, 2);
            
            totalBias = length(V2);
            bIdx = 1:totalBias;

            % generate new list
            for ix = 1:length(bIdx)
                write_str{bIdx(ix)} = sprintf('%d:  | %3.2f (| %s)', bIdx(ix), V2(ix), convertToPrefix(I2(ix), 'A'));
            end

            set(handles.biasgrid,'String',write_str); % write list
            set(handles.biasgrid,'Value',totalBias);
            
        end
        
        handles.numBIAS = totalBias;
        handles.numMEAS = handles.numBIAS;
        
    end
    
    % update counter text
    ctext = sprintf('Point 0 out of %s',num2str(handles.numBIAS));
    set(handles.countertext,'String',ctext);
    

       


end

