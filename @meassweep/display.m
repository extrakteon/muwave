function display(cIN)
% Method to display the properties of a meassweep object.

% Version 1.0
% Created 02-01-03 by Christian Fager
%
% Revision history.
% v1.0 -- Date 02-01-04
% Created.

cIN=meassweep(cIN);
disp('Measurement info')
display(cIN.Info);

disp('Sweep info')
if ~isempty(cIN.DataType), disp(sprintf('\tDatatype: %s',cIN.DataType)); end
if ~isempty(get(cIN,'Vgsq'))
    disp(sprintf('\tVgsq,min: %f',min(get(cIN,'Vgsq')))); 
    disp(sprintf('\tVgsq,max: %f',max(get(cIN,'Vgsq')))); 
end
if ~isempty(get(cIN,'Vdsq'))
    disp(sprintf('\tVdsq,min: %f',min(get(cIN,'Vdsq')))); 
    disp(sprintf('\tVdsq,max: %f',max(get(cIN,'Vdsq')))); 
end
if ~isempty(get(cIN,'Temp'))
    disp(sprintf('\tTemp,min: %f',min(get(cIN,'Temp')))); 
    disp(sprintf('\tTemp,max: %f',max(get(cIN,'Temp')))); 
end
if ~isempty(get(cIN,'PulseWidth'))
    disp(sprintf('\tPulse width,min: %f',min(get(cIN,'PulseWidth')))); 
    disp(sprintf('\tPulse width,max: %f',max(get(cIN,'PulseWidth')))); 
end
if ~isempty(get(cIN,'Period'))
    disp(sprintf('\tPulse period,min: %f',min(get(cIN,'Period')))); 
    disp(sprintf('\tPulse period,max: %f',max(get(cIN,'Period')))); 
end
if ~isempty(cIN.Data), disp(sprintf('\tNumber of measurements: %d',length(cIN.Data))); end
