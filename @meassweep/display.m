function display(cIN)
%DISPLAY Displays the meassweep properties.

%   (c) Kristoffer Andersson & Christian Fager, Chalmers University of Technology, Sweden

% $Header$
% $Author: fager $
% $Date: 2005-05-12 23:47:45 +0200 (Thu, 12 May 2005) $
% $Revision: 284 $ 
% $Log$
% Revision 1.7  2005/05/12 21:47:45  fager
% Proper display of multidimensional state variables
%
% Revision 1.6  2005/05/11 10:14:01  fager
% Allows diplay of cell vector properties.
%
% Revision 1.5  2005/04/27 08:21:30  fager
% Reformatted output format.
%
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
    if sum(size(values{k})>1)<2
        if length(unique(values{k}))==1
            disp(sprintf('\t%s: %g',names{k},min(values{k})));
        else
            disp(sprintf('\t%s,min: %g',names{k},min(min(values{k}))));
            disp(sprintf('\t%s,max: %g',names{k},max(max(values{k}))));
        end
    else
        tx = num2str(size(values{k}));
        [s,f,t] = regexp(tx,'(\d+)');
        formatstr = '';
        i = 1;
        stop = isempty(t);
        while ~stop
            stop = (i + 1) > length(t);
            if stop
                formatstr = strcat(formatstr,tx(t{i}(1):t{i}(2)));
            else
                formatstr = strcat(formatstr,tx(t{i}(1):t{i}(2)),'x');
                i = i + 1;
            end
        end
        disp(sprintf('\t%s: [%s]',names{k},formatstr));
    end
end
if ~isempty(cIN.data), disp(sprintf('\tNumber of measurements: %d',length(cIN.data))); end
