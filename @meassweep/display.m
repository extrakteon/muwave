function display(cIN)
%DISPLAY    Displays the meassweep properties.

% $Header$
% $Author: kristoffer $
% $Date: 2003-07-22 14:00:24 +0200 (Tue, 22 Jul 2003) $
% $Revision: 110 $ 
% $Log$
% Revision 1.3  2003/07/22 12:00:24  kristoffer
% Fixed a bug with emptu data-structures
%
% Revision 1.2  2003/07/21 08:31:38  fager
% Initial.
%

disp('Measurement info')
display(cIN.measmnt);

disp('Sweep info')
if isempty(cIN.data)
    statenames = '';
else
    testdata = cIN.data{1};
    statenames = get(get(testdata,'measstate'));
end

values=[];
names=[];
for k=1:length(statenames)
    val = get(cIN,statenames{k});
    if isnumeric(val)
        names{end+1} =statenames{k};
        values{end+1}=val;
    end
end

for k=1:length(names)
    if length(unique(values{k}))==1
        disp(sprintf('\t%s: %f',names{k},min(values{k}))); 
    else
        disp(sprintf('\t%s,min: %f',names{k},min(min(values{k}))));
        disp(sprintf('\t%s,max: %f',names{k},max(max(values{k}))));
    end
end
if ~isempty(cIN.data), disp(sprintf('\tNumber of measurements: %d',length(cIN.data))); end
