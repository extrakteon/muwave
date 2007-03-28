function display(cIN)
%DISPLAY Displays the meassweep properties.

%   (c) Kristoffer Andersson & Christian Fager, Chalmers University of Technology, Sweden

% $Header$
% $Author: fager $
% $Date: 2004-10-20 19:01:34 +0200 (Wed, 20 Oct 2004) $
% $Revision: 218 $ 
% $Log$
% Revision 1.4  2004/10/20 17:00:24  fager
% Help comments added
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
