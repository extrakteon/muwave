function handles = updateBias(handles, region)
%UPDATEBIAS takes the desired region number and update it
    % Sends the command to AddBias to update instead
    handles = AddBias(handles, region);    
end

