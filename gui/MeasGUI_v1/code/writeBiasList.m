function handles = writeBiasList(handles, region)
%WRITEBIASLIST takes the region desired and print it in the individual list box 


    % Tries to import the wanted data    
    v1 = [];
    v2 = [];
    try v1 = handles.bias.v1{region};
    end
    try v2 = handles.bias.v2{region};
    end
    
    if ~isempty(v1) && ~isempty(v2)
        
        % Gets bias grid
        [V1 V2] = meshgrid(v1,v2);
        V1 = V1(:); V2 = V2(:);
        V1V2 = [V1, V2];
        
        % Sorts the bias according to the selection
        if get(handles.RadioV1, 'Value')
            V1V2 = sortrows(V1V2, 1);
        else
            V1V2 = sortrows(V1V2, 2);
        end
        
        V1 = V1V2(:, 1);
        V2 = V1V2(:, 2);
        
        totalBias = length(V1);
        
        bIdx = 1:totalBias;
    
        % Generates new list
        for ix = 1:totalBias  
            write_str{bIdx(ix)} = sprintf('%d: %3.2f | %3.2f', bIdx(ix), V1(ix), V2(ix));
        end
        
        set(handles.listboxIndividual,'String',write_str);
        set(handles.listboxIndividual,'Value',totalBias);
        
    elseif ~isempty(v1) && isempty(v2)
        
        V1 = v1(:);
        V1 = sort(V1);
        
        totalBias = length(V1);

        bIdx = 1:totalBias;

        % generate new list
        for ix = 1:length(bIdx)
            write_str{bIdx(ix)} = sprintf('%d: %3.2f | ', bIdx(ix), V1(ix));
        end

        set(handles.listboxIndividual,'String',write_str); 
        set(handles.listboxIndividual,'Value',totalBias); 

    elseif isempty(v1) && ~isempty(v2)
        
        V2 = v2(:);
        V2 = sort(V2);
        
        totalBias = length(V2);

        bIdx = 1:totalBias;

        % generate new list
        for ix = 1:length(bIdx)
            write_str{bIdx(ix)} = sprintf('%d:  | %3.2f', bIdx(ix), V2(ix));
        end

        set(handles.listboxIndividual,'String',write_str); 
        set(handles.listboxIndividual,'Value',totalBias); 
        
    end
    


end

