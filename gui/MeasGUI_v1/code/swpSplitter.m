function swpCell = swpSplitter(swpIn, handles)
%SWPSPLITTER This function takes an swp object with multiple grids and splits it into a matrix with the separated swp objects
    
    try 

        DC1 = handles.instr.measure_dc1;
        DC2 = handles.instr.measure_dc2;

        gridNumbers = unique(swpIn.Gridnumber);
         
        
        % Get the swpIn data to matrix form
        data = [];
        idxV1 = 0;
        idxV2 = 0;
        if DC1
            data = [data, swpIn.V1_SET', swpIn.I1', swpIn.V1'];
            idxV1 = size(data, 2);
        end
        if DC2
            data = [data, swpIn.V2_SET', swpIn.I2', swpIn.V2'];
            idxV2 = size(data, 2);
        end
        data = [data, swpIn.Index', swpIn.Gridnumber'];
        
        
             
        
        
        
        % Work with every grid discretely
        newGridNumber = 1;
        for gridNumber = gridNumbers
            
            swp = meassweep;
            
            
            % Get the V_SET vetors that belongs the current grid number
            V1_SET = [];
            V2_SET = [];
            if DC1
                V1_SET = data(data(:, end) == gridNumber, idxV1-2);
            end
            if DC2
                V2_SET = data(data(:, end) == gridNumber, idxV2-2);
            end
            
            % Calculate the (when all grids are done) equvivalent bias grid
            BIAS = calcBIAS(V1_SET, V2_SET);
                        
            if DC1 && DC2
                if get(handles.RadioV1, 'Value')
                    BIAS = sortrows(BIAS, 1);
                else
                    BIAS = sortrows(BIAS, 2);
                end
            else
                BIAS = sort(BIAS);
            end
            
            
            for biasPoint = 1:size(BIAS, 1)
                
                % Retrieves the bias corresponding data
                if DC1 && DC2
                   measMatrix =...
                       data(logical([data(:, idxV1-2) == ...
                       BIAS(biasPoint, 1)].*[data(:, idxV2-2) == ...
                       BIAS(biasPoint, 2)]), :); % Checks so that the bias are in both V1 and V2        
                elseif DC1
                    measMatrix = data(data(:, idxV1-2) == BIAS(biasPoint, 1), :);
                elseif DC2
                    measMatrix = data(data(:, idxV2-2) == BIAS(biasPoint, 1), :);
                end
                
                % Checks so that only one set of points get used. The one
                % with the current grid number if possible
                if size(measMatrix, 1) > 1
                    if sum(measMatrix(:, end) == gridNumber)
                        measMatrix = measMatrix(measMatrix(:, end) == gridNumber, :);
                        measMatrix = measMatrix(1, :);
                    else
                        measMatrix = measMatrix(1, :);
                    end
                end
                
                meas = measMatrix;
            
                
                % Save the data to swp object
                sp = meassp;
                measmnt = get(sp, 'measmnt');
                measmnt = addprop(measmnt, 'Date', swpIn(meas(end-1)).Date);
                sp = set(sp, 'measmnt', measmnt);
                measstate = get(sp, 'measstate');
                if DC1
                    measstate = addprop(measstate, 'V1', swpIn(meas(end-1)).V1);
                    measstate = addprop(measstate, 'V1_SET', swpIn(meas(end-1)).V1_SET);
                    measstate = addprop(measstate, 'I1', swpIn(meas(end-1)).I1);
                    measstate = addprop(measstate, 'I1_SET', swpIn(meas(end-1)).I1_SET);
                end
                if DC2
                    measstate = addprop(measstate, 'V2', swpIn(meas(end-1)).V2);
                    measstate = addprop(measstate, 'V2_SET', swpIn(meas(end-1)).V2_SET);
                    measstate = addprop(measstate, 'I2', swpIn(meas(end-1)).I2);
                    measstate = addprop(measstate, 'I2_SET', swpIn(meas(end-1)).I2_SET);
                end
                measstate = addprop(measstate, 'Index', swpIn(meas(end-1)).Index); % The Index written is from the original swp to enable tracing
                measstate = addprop(measstate, 'Gridnumber', swpIn(meas(end-1)).Gridnumber);
                measstate = addprop(measstate, 'Gridname', swpIn(meas(end-1)).Gridname);
                sp = set(sp, 'measstate', measstate);
                try sp.data = swpIn(meas(end-1)).data; end %Tries to save SP data if S-param was measured                    
                swp = add(swp, sp);    
 
            end
            

            swpCell{newGridNumber} = swp;
            newGridNumber = newGridNumber + 1;

        end
    
    catch 
        swpCell{1} = swpIn;
        %warning('The swp object could not be split');
    end
    
    
    % splitTester(swpIn, swpCell) % If it is wanted to check to liability of the splittning
    
    
end



% Creates a regular grid from the existing values
function BIAS = calcBIAS(V1_SET, V2_SET)
    

    % Calculate each regular vector
    if ~isempty(V1_SET)
        maxV1 = max(V1_SET);
        minV1 = min(V1_SET);
        stepV1 = median(diff(unique(V1_SET))); % The step size should be the smallest unique step i the vector 
        if maxV1~=minV1
            V1_SET = minV1:stepV1:maxV1;
        else
            V1_SET = maxV1;
        end
    end
    
    if ~isempty(V2_SET)
        maxV2 = max(V2_SET);
        minV2 = min(V2_SET);
        stepV2 = median(diff(unique(V2_SET))); % The step size should be the smallest unique step i the vector
        if maxV2~=minV2
            V2_SET = minV2:stepV2:maxV2;
        else
            V2_SET = maxV2; 
        end
    end
    

    % Assign values to BIAS
    if ~(isempty(V1_SET) || isempty(V2_SET))
        [V1_SET, V2_SET] = meshgrid(V1_SET, V2_SET);
        BIAS = [V1_SET(:), V2_SET(:)];
    elseif ~isempty(V1_SET)
        BIAS = V1_SET(:);
    elseif ~isempty(V2_SET)
        BIAS = V2_SET(:);
    end


end




function splitTester(swpIn, swpCell)
    
    try swpIn.V1;
        DC1 = 1;
    catch
        DC1 = 0;
    end
    
    try swpIn.V2;
        DC2 = 1;
    catch
        DC2 = 0;
    end
    
    figure;
    if DC1 && DC2
        plot(swpIn.V1_SET, swpIn.V2_SET, 'o');
        figure
        hold on
        for i = 1:length(swpCell)
            plot(swpCell{i}.V1_SET, swpCell{i}.V2_SET, 'o', 'MarkerSize', 4*i);
        end
    elseif DC1
        plot(swpIn.V1_SET, 'o');
        figure
        hold on
        for i = 1:length(swpCell)
            plot(swpCell{i}.V1_SET, 'o', 'MarkerSize', 4*i);
        end
    elseif DC2
        plot(swpIn.V2_SET, 'o');
        figure
        hold on
        for i = 1:length(swpCell)
            plot(swpCell{i}.V2_SET, 'o', 'MarkerSize', 4*i);
        end
    end
    
    
    

end



