function handles = ClearBias(handles)

% reset constants
handles.num_regions = 0;
handles.numBIAS = 0;
handles.numMEAS = handles.numGL;
clear handles.bias;

set(handles.buttonUpdate, 'Enable', 'off');

% % update the bias region information
% set(handles.v1start,'String','0');
% set(handles.v1stop,'String','0');
% set(handles.v1step,'String','0');
% set(handles.i1comp,'String','0');
% set(handles.p1comp,'String','0');
% set(handles.v2start,'String','0');
% set(handles.v2stop,'String','0');
% set(handles.v2step,'String','0');
% set(handles.i2comp,'String','0');
% set(handles.p2comp,'String','0');

% reset bias grid
set(handles.biasgrid,'String','');

%reset individual grid
set(handles.listboxIndividual,'String','');
set(handles.popupGrids,'String',' ');
set(handles.popupGrids,'Value', 1);
set(handles.popupGrids, 'Enable', 'off');
set(handles.buttonDelete, 'Enable', 'inactive');

try
    % update counter text
    ctext = sprintf('Point 0 out of %s',num2str(handles.numMEAS));
    set(handles.countertext,'String',ctext);
catch
end