function varargout = MeasIV(varargin)
% MEASIV M-file for MeasIV.fig
%      MEASIV, by itself, creates a new MEASIV or raises the existing
%      singleton*.
%
%      H = MEASIV returns the handle to a new MEASIV or the handle to
%      the existing singleton*.
%
%      MEASIV('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MEASIV.M with the given input arguments.
%
%      MEASIV('Property','Value',...) creates a new MEASIV or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MeasIV_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MeasIV_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MeasIV

% Last Modified by GUIDE v2.5 01-Aug-2011 14:07:50

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MeasIV_OpeningFcn, ...
                   'gui_OutputFcn',  @MeasIV_OutputFcn, ...
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



% --- Executes just before MeasIV is made visible.
function MeasIV_OpeningFcn(hObject, eventdata, handles, varargin)


% Set delete picture
deleteIm = importdata('button_erase.bmp');
%set the image as the button background
set(handles.buttonDelete,'CDATA',deleteIm);


% Initialize to later determine if one of the instruments are the Agilent 4156 DC
global INSTR_4156;
INSTR_4156 = 0;

% Choose default command line output for MeasIV
handles.output = hObject;

% get instrument information
instruments = varargin{1};

% get settings
handles.SETUP = varargin{2};

% initiate instruments
h_wb = varargin{3};
if handles.SETUP.DEMO
    % DEMO measurement
     %set(handles.measure,'Enable','Off'); 
     handles.SETUP.MEASTYPE = 'DEMO';
     handles.instr.measure_dc1 = 1; %input('DC1: '); 
     handles.instr.measure_dc2 = 1; %input('DC2: '); 
else
    
        
    handles.instr = init_instr(instruments,h_wb);
    
    % Check if Agilent 4156 Analyzer is choosen 
    if strcmp(instruments.dc1, 'Agilent 4156 Analyzer') ||...
            strcmp(instruments.dc2, 'Agilent 4156 Analyzer')
%         set(handles.removeDuplicates, 'Visible', 'off');
%         set(handles.biasgrid, 'Visible', 'off');
%         set(handles.textIndex, 'Visible', 'off');
%         set(handles.textDC4156, 'Visible', 'on');
%         set(handles.countertext, 'Visible', 'off');            
        INSTR_4156 = 1;
    end  
    
end
close(h_wb);

% initiate save path
handles.SavePath = 'data/*.mat';

% initiate number of meas points
handles.numGL = 0;
handles.numGL2 = 0;
handles.numBIAS = 0;
handles.numMEAS = 0;

% set number of bias regions to 0
handles.num_regions = 0;

% set axes labels
axes(handles.ax1);
xlabel('V_1');
ylabel('I_1');
% hold on;

axes(handles.ax2);
xlabel('V_2');
ylabel('I_2');
% hold on;

% check number of bias supplies
if ~handles.instr.measure_dc1 % disable bias 1
    set(handles.v1start,'Enable','Off');
    set(handles.v1stop,'Enable','Off');
    set(handles.v1step,'Enable','Off');
    set(handles.i1comp,'Enable','Off');
    set(handles.p1comp,'Enable','Off');
    set(handles.RadioV1,'Enable','Off');
    set(handles.RadioV2,'Enable','Off');
end
if ~handles.instr.measure_dc2 % disable bias 2
    set(handles.v2start,'Enable','Off');
    set(handles.v2stop,'Enable','Off');
    set(handles.v2step,'Enable','Off');
    set(handles.i2comp,'Enable','Off');
    set(handles.p2comp,'Enable','Off');
    set(handles.RadioV1,'Enable','Off');
    set(handles.RadioV2,'Enable','Off');
else
    if ~handles.instr.measure_dc1
        set(handles.RadioV2,'Value', 1);
    end  
end


% Call for measurement if auto measurement is selected
if handles.SETUP.AUTO
    handles = loadsetup_Callback(hObject, eventdata, handles);
    measure_Callback(hObject, eventdata, handles);
    exit_Callback(hObject, eventdata, handles)
    if handles.SETUP.DEMO == 0
        instrreset;
    end
    % Update handles structure
    guidata(hObject, handles);
    uiresume(handles.figure);
else
    % Update handles structure
    guidata(hObject, handles);

    % UIWAIT makes MeasIV wait for user response (see UIRESUME)
    uiwait(handles.figure);
end







function varargout = MeasIV_OutputFcn(hObject, eventdata, handles) 
delete(hObject);

function biasgrid_Callback(hObject, eventdata, handles)
function biasgrid_CreateFcn(hObject, eventdata, handles)
function v1start_Callback(hObject, eventdata, handles)
function v1start_CreateFcn(hObject, eventdata, handles)
function v1stop_Callback(hObject, eventdata, handles)
function v1stop_CreateFcn(hObject, eventdata, handles)
function v1step_Callback(hObject, eventdata, handles)
function v1step_CreateFcn(hObject, eventdata, handles)
function v2start_Callback(hObject, eventdata, handles)
function v2start_CreateFcn(hObject, eventdata, handles)
function v2stop_Callback(hObject, eventdata, handles)
function v2stop_CreateFcn(hObject, eventdata, handles)
function v2step_Callback(hObject, eventdata, handles)
function v2step_CreateFcn(hObject, eventdata, handles)

function addbias_Callback(hObject, eventdata, handles)
handles = AddBias(handles); % add bias grid

% Update handles structure
guidata(hObject, handles);

function clearbias_Callback(hObject, eventdata, handles)
handles = ClearBias(handles);
% Update handles structure
guidata(hObject, handles);

function i1comp_Callback(hObject, eventdata, handles)
function i1comp_CreateFcn(hObject, eventdata, handles)
function i2comp_Callback(hObject, eventdata, handles)
function i2comp_CreateFcn(hObject, eventdata, handles)
function p1comp_Callback(hObject, eventdata, handles)
function p1comp_CreateFcn(hObject, eventdata, handles)
function p2comp_Callback(hObject, eventdata, handles)
function p2comp_CreateFcn(hObject, eventdata, handles)

function measure_Callback(hObject, eventdata, handles)

global IV_SWP;


DC1 = handles.instr.measure_dc1;
DC2 = handles.instr.measure_dc2;

% check if bias points are given
if handles.numBIAS == 0
    msgbox('No Bias Point is given. Please select at least one Bias Point!',...
        'Error','error');
else
    % disable measure button
    set(handles.measure,'Enable','Off'); 
    % enable stop button
    set(handles.stop,'Enable','On');
    
    global MEAS_CANCEL; % global variable for canceling measurement
    MEAS_CANCEL = false;  
    
    
    % Agilent 4156 i choosen, call on MeasureAnalyzer4156
    global INSTR_4156;
    if INSTR_4156        
        % Measure
        
        for region = 1:handles.num_regions 
            swpElement = MeasureAnalyzer4156(handles, region);
            swp{region} = swpElement;
        end
        
    else
        
        % Get the bias grid
        BIAS = GetBIAS(handles);

       
        if DC1 && DC2
            BIASUpdate = [BIAS.V1 BIAS.V2 BIAS.I1 BIAS.I2, BIAS.REGION];
            if get(handles.RadioV1, 'Value')
                BIASUpdate = sortrows(BIASUpdate, [1 2 3 4 5]);
            else
                BIASUpdate = sortrows(BIASUpdate, [2 1 3 4 5]);
            end
            
        elseif DC1 && ~DC2
            BIASUpdate = [BIAS.V1 BIAS.I1, BIAS.REGION];
            BIASUpdate = sortrows(BIASUpdate);
        elseif ~DC1 && DC2
            BIASUpdate = [BIAS.V2 BIAS.I2, BIAS.REGION];
            BIASUpdate = sortrows(BIASUpdate);
        end

        if get(handles.removeDuplicates, 'Value')
            [trashMatrix, uniqueRowsIndex, trashVector] =...
                unique(BIASUpdate(:, 1:end-1), 'rows');
            BIASUpdate = BIASUpdate(uniqueRowsIndex, :);
        end
        
        
        
        
        if DC1 && DC2
            
            BIAS.V1 = BIASUpdate(:, 1);
            BIAS.V2 = BIASUpdate(:, 2);
            BIAS.I1 = BIASUpdate(:, 3);
            BIAS.I2 = BIASUpdate(:, 4);
            BIAS.REGION = BIASUpdate(:, 5);

        elseif DC1 && ~DC2
            BIAS.V1 = BIASUpdate(:, 1);
            BIAS.I1 = BIASUpdate(:, 2);
            BIAS.REGION = BIASUpdate(:, 3);

        elseif ~DC1 && DC2
            BIAS.V2 = BIASUpdate(:, 1);
            BIAS.I2 = BIASUpdate(:, 2);
            BIAS.REGION = BIASUpdate(:, 3);
        end
        
        
        % refresh the number of points
        handles.numBIAS = size(BIASUpdate, 1);
        BIAS.NUMPOINTS = size(BIASUpdate, 1);

       
        
        % set axes scale
        if DC1
            if min(BIAS.V1) ~= max(BIAS.V1)
                axes(handles.ax1);
                axis([min(BIAS.V1) max(BIAS.V1) -min(BIAS.I1) max(BIAS.I1)]);
            end
        end
        if DC2
            if min(BIAS.V2) ~= max(BIAS.V2)
                axes(handles.ax2);
                axis([min(BIAS.V2) max(BIAS.V2) 0 max(BIAS.I2)]);
            end
        end

        % measure
        swp = MeasureIV(handles.instr,BIAS,handles);
        
        IV_SWP = swp;
 
        set(handles.buttonMDIF, 'Enable', 'On');%enable save mdif button
        set(handles.buttonCSV, 'Enable', 'On');%enable save csv button
        set(handles.buttonMAT, 'Enable', 'On');%enable save mat button
        
    end
    
    % Save the measurement 
    handles = saveMeas(swp, handles);
    
    % Update handles structure
    guidata(hObject, handles);  
end
    




function figure_CreateFcn(hObject, eventdata, handles)
function mv1_Callback(hObject, eventdata, handles)
function mv1_CreateFcn(hObject, eventdata, handles)
function mi1_Callback(hObject, eventdata, handles)
function mi1_CreateFcn(hObject, eventdata, handles)
function mv2_Callback(hObject, eventdata, handles)
function mv2_CreateFcn(hObject, eventdata, handles)
function mi2_Callback(hObject, eventdata, handles)
function mi2_CreateFcn(hObject, eventdata, handles)




function changePrimarySweep_SelectionChangeFcn(hObject, eventdata, handles)
    
    try
    
        if handles.numBIAS > 0

            BIAS = GetBIAS(handles);
            AllPoints = [BIAS.V1, BIAS.V2, BIAS.I1, BIAS.I2];
            
            if get(handles.removeDuplicates, 'Value')
                AllPoints = unique(AllPoints, 'rows');
            end

            if handles.RadioV1 == eventdata.NewValue
                AllPoints = sortrows(AllPoints, [1 2 3 4]);
            else
                AllPoints = sortrows(AllPoints, [2 1 3 4]);
            end

            V1 = AllPoints(:, 1);
            V2 = AllPoints(:, 2);
            I1 = AllPoints(:, 3);
            I2 = AllPoints(:, 4);

            totalBias = length(V1);
            bIdx = 1:totalBias;

            % generate list
            for ix = 1:totalBias  
                write_str{bIdx(ix)} =...
                    sprintf('%d: %3.2f | %3.2f (%s | %s)',...
                    bIdx(ix), V1(ix), V2(ix), convertToPrefix(I1(ix), 'A'),...
                    convertToPrefix(I2(ix), 'A'));
            end

            set(handles.biasgrid,'String',write_str); % write list
            set(handles.biasgrid,'Value',totalBias); % change selected region
            handles.numBIAS = totalBias;


            % Update individual list
            try region = get(handles.popupGrids, 'Value');
                handles = writeBiasList(handles, region);
            end

        end
    end
   

function exit_Callback(hObject, eventdata, handles)
if handles.SETUP.DEMO == 0
    instrreset;
end
uiresume(handles.figure);

function savesetup_Callback(hObject, eventdata, handles)
% save bias settings
SaveSetup(handles,'IV');

function handles = loadsetup_Callback(hObject, eventdata, handles)
% load bias
handles = LoadSetup(handles,'IV');
% change the individual grid to the last grid in the list
handles = changeBias(handles, handles.num_regions);

if handles.num_regions > 0 
    % Updates the grid listbox and the popmenu
    for reg = 1:handles.num_regions
        gridList{reg} =   ['(' num2str(reg) ') ' handles.bias.name{reg}];
    end
    set(handles.popupGrids, 'String', gridList(:));
    set(handles.popupGrids, 'Value', handles.num_regions);
    set(handles.popupGrids, 'Enable', 'on');
    set(handles.buttonDelete, 'Enable', 'on');
    set(handles.buttonUpdate, 'Enable', 'on');
end

% update counter text
ctext = sprintf('Point 0 out of %s',num2str(handles.numBIAS));
set(handles.countertext,'String',ctext);


% Update handles structure
guidata(hObject, handles);

function figure_CloseRequestFcn(hObject, eventdata, handles)
uiresume(handles.figure); % close and resume

function stop_Callback(hObject, eventdata, handles)
global MEAS_CANCEL; % global variable for canceling measurement
MEAS_CANCEL = true; % cancel measurement



function removeDuplicates_Callback(hObject, eventdata, handles)
    
    %This functions checks if duplicates are desirable and then either
    %deletes or keeps them and print a new list.
    
    try
    
        DC1 = handles.instr.measure_dc1;
        DC2 = handles.instr.measure_dc2;
        BIAS = GetBIAS(handles);
        
        if DC1 && DC2
            BiasUpdate = [BIAS.V1 BIAS.V2, BIAS.I1, BIAS.I2];
        elseif DC1 && ~DC2
            BiasUpdate = [BIAS.V1 BIAS.I1];
        elseif ~DC1 && DC2
            BiasUpdate = [BIAS.V2 BIAS.I2];
        end
        
        if get(hObject, 'Value')
            BiasUpdate = unique(BiasUpdate, 'rows');    
        end
        
        totalBias = size(BiasUpdate, 1);
        bIdx = 1:totalBias;

        if DC1 && DC2
            if get(handles.RadioV1, 'Value')
                BiasUpdate = sortrows(BiasUpdate, [1 2 3 4]);
            else
                BiasUpdate = sortrows(BiasUpdate, [2 1 3 4]);
            end
            V1 = BiasUpdate(:, 1);
            V2 = BiasUpdate(:, 2);
            I1 = BiasUpdate(:, 3);
            I2 = BiasUpdate(:, 4);
            % generate list
            for ix = 1:totalBias   %length(bIdx)
                write_str{bIdx(ix)} =...
                    sprintf('%d: %3.2f | %3.2f (%s | %s)',...
                    bIdx(ix), V1(ix), V2(ix), convertToPrefix(I1(ix), 'A'),...
                    convertToPrefix(I2(ix), 'A'));
            end

        elseif DC1 && ~DC2     
            BiasUpdate = sortrows(BiasUpdate, [1 2]);
            V1 = BiasUpdate(:, 1);
            I1 = BiasUpdate(:, 2);
            % generate list
            for ix = 1:totalBias   %length(bIdx)
                write_str{bIdx(ix)} =...
                    sprintf('%d: %3.2f | (%s |)',...
                    bIdx(ix), V1(ix), convertToPrefix(I1(ix), 'A'));
            end

        elseif ~DC1 && DC2
            BiasUpdate = sortrows(BiasUpdate, [1 2]);
            V2 = BiasUpdate(:, 1);
            I2 = BiasUpdate(:, 2);
            % generate list
            for ix = 1:totalBias   %length(bIdx)
                write_str{bIdx(ix)} =...
                    sprintf('%d:  | %3.2f (| %s)',...
                    bIdx(ix), V2(ix), convertToPrefix(I2(ix), 'A'));
            end        
        end

        set(handles.biasgrid,'String',write_str); % write list
        set(handles.biasgrid,'Value',totalBias); % change selected region 
        handles.numBIAS = totalBias;

        % update counter text
        ctext = sprintf('Point 0 out of %s',num2str(handles.numBIAS));
        set(handles.countertext,'String',ctext);
    
    end




% --- Executes on selection change in popupGrids.
function popupGrids_Callback(hObject, eventdata, handles)
    try region = get(handles.popupGrids, 'Value');
        handles = changeBias(handles, region);
    catch
        errordlg('The choice of grid is not legitimate');
    end
    
    % Update handles structure
    guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function popupGrids_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'),...
        get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listboxIndividual.
function listboxIndividual_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function listboxIndividual_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'),...
        get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in buttonUpdate.
function buttonUpdate_Callback(hObject, eventdata, handles)
    try region = get(handles.popupGrids, 'Value');
        handles = updateBias(handles, region);
    catch
        errordlg('The choice of grid is not legitimate');
    end
    
    % Update handles structure
    guidata(hObject, handles);



% --- Executes on button press in buttonDelete.
function buttonDelete_Callback(hObject, eventdata, handles)
    
if strcmp(get(handles.popupGrids, 'Enable'), 'on')
    try region = get(handles.popupGrids, 'Value');
        handles = deleteBias(handles, region);
    catch
        errordlg('The choice of grid is not legitimate');
    end 
end    
    % Update handles structure
    guidata(hObject, handles);

function biasgrid_ButtonDownFcn(hObject, eventdata, handles)


        


% --- Executes during object creation, after setting all properties.
function buttonDelete_CreateFcn(hObject, eventdata, handles)



function editGridname_Callback(hObject, eventdata, handles)
% hObject    handle to editGridname (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editGridname as text
%        str2double(get(hObject,'String')) returns contents of editGridname as a double


% --- Executes during object creation, after setting all properties.
function editGridname_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editGridname (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'),...
        get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in buttonMDIF.
function buttonMDIF_Callback(hObject, eventdata, handles)
    global IV_SWP;
    swp = IV_SWP;
    
    handles = saveMDIF(swp, handles);
    
    % Update handles structure
    guidata(hObject, handles);  


% --- Executes on button press in buttonCSV.
function buttonCSV_Callback(hObject, eventdata, handles)
    global IV_SWP;
    swp = IV_SWP;
    
    handles = saveCSV(swp, handles);
    
    % Update handles structure
    guidata(hObject, handles); 


% --- Executes on button press in buttonLoadSWP.
function buttonLoadSWP_Callback(hObject, eventdata, handles)
    global IV_SWP;

    [FileName,PathName] = uigetfile({'*.mat', 'MAT-files'}, handles.SavePath);
    
    try load([PathName, FileName])
        handles = ClearBias(handles);
        IV_SWP = swp;
        handles = gridRestore(IV_SWP, handles);
        
        set(handles.buttonMDIF, 'Enable', 'On');%enable save mdif button
        set(handles.buttonCSV, 'Enable', 'On');%enable save csv button
        set(handles.buttonMAT, 'Enable', 'On');%enable save mat button
        
        try
            % update plots and data boxes
            if handles.instr.measure_dc1
                axes(handles.ax1);
                plot(swp.V1,swp.I1,'.');
                xlabel('V_1');
                ylabel('\midI_1\mid');
            end
            if handles.instr.measure_dc2
                axes(handles.ax2);
                plot(swp.V2,swp.I2,'.');
                xlabel('V_2');
                ylabel('I_2');
            end
        catch
        end
           
    catch
        if ~isequal(PathName, 0)
            errordlg('The file could not be read!');
        end
        handles = ClearBias(handles);
    end
    
    % Update handles structure
    guidata(hObject, handles);  
    


% --- Executes on button press in buttonMAT.
function buttonMAT_Callback(hObject, eventdata, handles)

    global IV_SWP;
    swp = IV_SWP;

    handles = saveMeas(swp, handles);
    
    % Update handles structure
    guidata(hObject, handles);  
