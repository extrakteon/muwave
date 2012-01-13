function prefixString = convertToPrefix(num, unit)
%CONVERTTOPREFIX This function takes a numeric variable and converts it to a string with prefix and the specified
%   Example:
%   convertToPrefix(0.001, 'A') -> 1 mA

    if ~isnumeric(num) || ~ischar(unit)
        errordlg('Wrong input parameters to convertToPrefix');
        return
    else
        
    compareCell = {1e9, 'G'; 1e6, 'M'; 1e3, 'k'; 1, ''; 1e-3, 'm';...
                   1e-6, 'µ'; 1e-9, 'n'; 1e-12, 'p'};
               
    for idx = 1:length(compareCell)
        possibleStrings{idx} = [num2str(num/compareCell{idx, 1}, 2) ' ' compareCell{idx, 2} unit];
        possibleStringsLength(idx, 1) = length(possibleStrings{idx});
        possibleStringsLength(idx, 2) = idx;
    end
    
    possibleStringsLength = sortrows(possibleStringsLength);
    prefixString = possibleStrings{possibleStringsLength(1, 2)};

end

