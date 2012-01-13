function handles = gridRestore(swp, handles)
%GRIDRESTORE Takes an swp object and tries to restore the grid that was its creator

    DC1 = handles.instr.measure_dc1;
    DC2 = handles.instr.measure_dc2;
    swpCell = swpSplitter(swp, handles);
    
    
    [uniqueElements, uniquePositions, trash] = unique(swp.Gridnumber);
    idx = 1;
    for position = uniquePositions
        Names{idx} = swp(position).Gridname;
        idx = idx + 1;
    end
    
    
    for cellNumber = 1:length(swpCell)
        currentSWP = swpCell{cellNumber};
        
        if DC1
            V1 = currentSWP.V1_SET;
            set(handles.v1start, 'String', num2str(min(V1)));
            set(handles.v1stop, 'String', num2str(max(V1)));
            
            if isequal(min(V1), max(V1))
                set(handles.v1step, 'String', '1');
            else
                set(handles.v1step, 'String', num2str(median(diff(unique(V1))))); % The step size should be the smallest unique step i the vector
            end
            
            I1 = currentSWP.I1_SET;
            set(handles.i1comp, 'String', num2str(max(unique(I1))));
            
            % Calculate the power compliance if there are any
            if length(unique(I1)) > 1
                P1 = V1.*I1;
                p1 = max(abs(P1));
                set(handles.p1comp, 'String', num2str(p1));
            else
                set(handles.p1comp, 'String', '0');
            end
            
        end
        
        
        if DC2
            V2 = currentSWP.V2_SET;
            set(handles.v2start, 'String', num2str(min(V2)));
            set(handles.v2stop, 'String', num2str(max(V2)));
            
            if isequal(min(V2), max(V2))
                set(handles.v2step, 'String', '1');
            else
                set(handles.v2step, 'String', num2str(median(diff(unique(V2))))); % The step size should be the smallest unique step i the vector
            end
            
            I2 = currentSWP.I2_SET;
            set(handles.i2comp, 'String', num2str(max(unique(I2))));
            
            % Calculate the power compliance if there are any
            if length(unique(I2)) > 1
                P2 = V2.*I2;
                p2 = max(abs(P2));
                set(handles.p2comp, 'String', num2str(p2));
            else
                set(handles.p2comp, 'String', '0');
            end
            
        end
        
        try set(handles.editGridname, 'String', Names{cellNumber}); 
        catch
            set(handles.editGridname, 'String', '[Grid name]');
        end
        
        handles = AddBias(handles);
        
        
        
    end

    


end

