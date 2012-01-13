function varargout = PlotManager(varargin)
    % PLOTMANAGER MATLAB code for PlotManager.fig
    %      PLOTMANAGER, by itself, creates a new PLOTMANAGER or raises the existing
    %      singleton*.
    %
    %      H = PLOTMANAGER returns the handle to a new PLOTMANAGER or the handle to
    %      the existing singleton*.
    %
    %      PLOTMANAGER('CALLBACK',hObject,eventData,handles,...) calls the local
    %      function named CALLBACK in PLOTMANAGER.M with the given input arguments.
    %
    %      PLOTMANAGER('Property','Value',...) creates a new PLOTMANAGER or raises the
    %      existing singleton*.  Starting from the left, property value pairs are
    %      applied to the GUI before PlotManager_OpeningFcn gets called.  An
    %      unrecognized property name or invalid value makes property application
    %      stop.  All inputs are passed to PlotManager_OpeningFcn via varargin.
    %
    %      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
    %      instance to run (singleton)".
    %
    % See also: GUIDE, GUIDATA, GUIHANDLES

    % Edit the above text to modify the response to help PlotManager

    % Last Modified by GUIDE v2.5 21-Jul-2011 16:16:08

    % Begin initialization code - DO NOT EDIT
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
                       'gui_Singleton',  gui_Singleton, ...
                       'gui_OpeningFcn', @PlotManager_OpeningFcn, ...
                       'gui_OutputFcn',  @PlotManager_OutputFcn, ...
                       'gui_LayoutFcn',  [] , ...
                       'gui_Callback',   []);
    if nargin && ischar(varargin{1})
        gui_State.gui_Callback = str2func(varargin{1});
    end

    if nargout
        [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
    else
        gui_mainfcn(gui_State, varargin{:});
    end
    % End initialization code - DO NOT EDIT


% --- Executes just before PlotManager is made visible.
function PlotManager_OpeningFcn(hObject, eventdata, handles, varargin)

    % Choose default command line output for PlotManager
    handles.output = hObject;

    global SP_SWP;
    global LIST_STRING;
    swp = SP_SWP;
    
    

    

    % Gets the measstates of the swp object
    LIST_STRING = get(swp.measstate);

    % Exclude Meastype and Index
    searchIndex = 1;
    while ~(searchIndex > length(LIST_STRING))
        if isequal(LIST_STRING(searchIndex), {'MeasType'}) || isequal(LIST_STRING(searchIndex), {'Index'})
            LIST_STRING(searchIndex) = [];
            % Compensate in index for the removed cell by not adding 1 to index
        else
            searchIndex = searchIndex+1;
        end
    end


    % Add desired variables to the list if they exists as a property
    stringVars = {'S11', 'S12', 'S21', 'S22', 'Freq'};
    for i = 1:length(stringVars)
        try get(swp, stringVars{i});
            LIST_STRING = [LIST_STRING, stringVars{i}];
            if strcmp(stringVars{i}, 'Freq')
                LIST_STRING = [LIST_STRING, 'w'];
            end
        end
    end           


    % Prepare the listboxes at Basic plot
    set(handles.listboxFirst, 'String', LIST_STRING);
    set(handles.listboxFirst, 'Value', 1);



    fillPopmenus(handles);




    % Update handles structure
    guidata(hObject, handles);

function varargout = PlotManager_OutputFcn(hObject, eventdata, handles) 
    % Get default command line output from handles structure
    varargout{1} = handles.output;


function  fillPopmenus(handles)
    
    fillText = {' '};
    
    try
        fileName = 'bookmarkedExpressions.lst';
        fid = fopen(fileName);
        fillText = textscan(fid, '%s');
    end
    
    set(handles.popupX, 'String', fillText{:});
    set(handles.popupY, 'String', fillText{:});
    
    try fclose(fid);
    end




function listboxFirst_Callback(hObject, eventdata, handles)


function listboxFirst_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

    
    % Tries to import the wanted value in swp
    function [vector, vectorLength] = getDataVector(swp, Value)
        
        % Enables the use of w as an variable
        originalValue = Value;
        if strcmp(originalValue, 'w')
            Value = 'Freq';
        end
        
        % Imports he wanted vector
        try vector = get(swp, Value);
            vectorLength = length(vector);
            if strcmp(originalValue, 'w')
                vector = 2*pi*vector;
            end
        catch
            warning([Value ' could not be imported for ploting']);
            vector = [];
            vectorLength = 0;
        end
        

        
    


function buttonGeneratePlot2_Callback(hObject, eventdata, handles)
    
    global SP_SWP;
    global LIST_STRING;
    global FILENAME;
    
    swp = SP_SWP;
    
    %Tries to import w as an variable
    try w = 2*pi*get(swp, 'Freq');
    end
    
    
    xAxisText = get(handles.editXAxis, 'String');
    yAxisText = get(handles.editYAxis, 'String');
    
    %Checks that both x and y fields are filled in
    if isempty(xAxisText) || isempty(yAxisText)
        errordlg('Both of the axis fields have to be filled in');
        return;
    end    
    
    %Imports the variables that is going to be ploted
    numberOfVars = 0;
    vectorLength = [];
    for listIndex = 1:length(LIST_STRING)
        if strfind([xAxisText, ' ',yAxisText], LIST_STRING{listIndex})
            numberOfVars = numberOfVars + 1;
            eval(['[' LIST_STRING{listIndex} ' vectorLength(numberOfVars)] = getDataVector(swp, LIST_STRING{listIndex});']);
        end
    end
    
    %Checks that all variables have the same amount of points
    if numberOfVars > 0
        if ~isempty(find(vectorLength-vectorLength(1), 1))
            errordlg('The number of values in X and Y don''t match');
            return;
        end
    end
    
    %Converts to elementwise operations
    xText = matrixToElementOperations(xAxisText);
    yText = matrixToElementOperations(yAxisText);
    
    xAxisText = strrep(xAxisText, 'SET', '{SET}');
    yAxisText = strrep(yAxisText, 'SET', '{SET}');
    
    %Specifies the plot type
    plotType = 'plot';    
    if get(handles.radioLogLog, 'Value')
        plotType = 'loglog';
    elseif get(handles.radioLinLogX, 'Value')
        plotType = 'semilogx';
    elseif get(handles.radioLinLogY, 'Value')
        plotType = 'semilogy';
    end
    
    
    %Tries to interpret the plot command
    tempHandle = figure('Visible', 'off');
    try eval([plotType '(' xText ', ' yText ')']);
        
        
        filename = FILENAME;
        if isequal(filename, 0)
            filename = '';
        end
        
        
        set(tempHandle, 'Visible', 'on');
        set(tempHandle, 'Name', ['[' xAxisText ', ' yAxisText '] ''' filename '''']);
        set(tempHandle, 'NumberTitle', 'off');
        
        xlabel(xAxisText);
        ylabel(yAxisText);
        
        saveEquations(handles);
        
    catch
        close(tempHandle);
        errordlg('All input must be interpretable by MATLAB');
        return;
    end
    
    %Updates the popmenus
    fillPopmenus(handles);
    
    
    
    
    
function plotTextOut = matrixToElementOperations(plotTextIn)
    
    plotTextIn = strrep(plotTextIn, '*','.*');
    plotTextIn = strrep(plotTextIn, '/','./');
    plotTextIn = strrep(plotTextIn, '^','.^');
    plotTextIn = strrep(plotTextIn, '..','.');
    plotTextOut = plotTextIn;
    

% Saves any newly inputed equation 
function saveEquations(handles)
    try
        % Gets the data from the file
        fileText = {''};
        try
            fileName = 'bookmarkedExpressions.lst';
            fid = fopen(fileName);
            fileText = textscan(fid, '%s');            
        end
        
        try fclose(fid);
        end

        % Append the text from the textboxes
        xText = get(handles.editXAxis, 'String');
        yText = get(handles.editYAxis, 'String');
        fileText = fileText{:};

        if ~isempty(xText)
            fileText{length(fileText)+1} = xText;    
        end

        if ~isempty(yText)
            fileText{length(fileText)+1} = yText;    
        end

        % Get the unique list
        fileText = unique(fileText);

        % Write to file
        fid = fopen(fileName, 'w+');
        fprintf(fid, '%s \n', fileText{:});   
        
    catch
        warning('The equation could''nt be saved');
    end
    
    try fclose(fid);
    end
    
        
    
    
    

function editXAxis_Callback(hObject, eventdata, handles)
function editYAxis_Callback(hObject, eventdata, handles)

% --- Executes on selection change in popupX.
function popupX_Callback(hObject, eventdata, handles)
    contents = cellstr(get(hObject,'String'));
    set(handles.editXAxis, 'String', contents{get(hObject,'Value')});
    
% --- Executes on selection change in popupY.
function popupY_Callback(hObject, eventdata, handles)
    contents = cellstr(get(hObject,'String'));
    set(handles.editYAxis, 'String', contents{get(hObject,'Value')}); 
    

function editXAxis_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function editYAxis_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function popupX_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function popupY_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





% --- Executes on button press in buttonExit.
function buttonExit_Callback(hObject, eventdata, handles)
    closereq;



function editEval_Callback(hObject, eventdata, handles)
% hObject    handle to editEval (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editEval as text
%        str2double(get(hObject,'String')) returns contents of editEval as a double


% --- Executes during object creation, after setting all properties.
function editEval_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editEval (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in buttonEval.
function buttonEval_Callback(hObject, eventdata, handles)

    global SP_SWP;
    swp = SP_SWP;    
    
    String = get(handles.editEval, 'String');

    childrenBefore = length(get(handles.figure, 'children'));

    evalString = [];

    for line = 1:size(String, 1)

        evalString = [evalString, String(line, :), ','];   
    end

    eval(evalString);

    childrenAfter = length(get(handles.figure, 'children'));

    if childrenAfter > childrenBefore
        Children = get(handles.figure, 'children');
        set(Children(1), 'Visible', 'off');
        errordlg('Type FIGURE before ploting or equivalent!');
    end


    function generateCustomPlot(xText, yText)
        global SP_SWP;
        global FILENAME;
        swp = SP_SWP;
        f = figure;

        eval(['plot(' xText ', ' yText ', ''o'');']);
        xlabel(xText);
        ylabel(yText);

        filename = FILENAME;
        if isequal(filename, 0)
            filename = 'No filename';
        end


        set(f, 'Name', ['[' xText ', ' yText '] ' '''' filename '''']);
        set(f, 'NumberTitle', 'off');


% --- Executes on button press in buttonV1I1.
function buttonV1I1_Callback(hObject, eventdata, handles)
   generateCustomPlot('swp.V1', 'abs(swp.I1)');

% --- Executes on button press in buttonV2I2.
function buttonV2I2_Callback(hObject, eventdata, handles)
    generateCustomPlot('swp.V2', 'swp.I2');
   
% --- Executes on button press in buttonS21Freq.
function buttonS21Freq_Callback(hObject, eventdata, handles)
    generateCustomPlot('1e-9.*swp.Freq', 'db(swp.S21)');

