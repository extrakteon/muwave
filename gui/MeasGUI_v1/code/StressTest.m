function varargout = StressTest(varargin)
% STRESSTEST MATLAB code for StressTest.fig
%      STRESSTEST, by itself, creates a new STRESSTEST or raises the existing
%      singleton*.
%
%      H = STRESSTEST returns the handle to a new STRESSTEST or the handle to
%      the existing singleton*.
%
%      STRESSTEST('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in STRESSTEST.M with the given input arguments.
%
%      STRESSTEST('Property','Value',...) creates a new STRESSTEST or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before StressTest_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to StressTest_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help StressTest

% Last Modified by GUIDE v2.5 04-Aug-2011 13:34:44

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @StressTest_OpeningFcn, ...
                   'gui_OutputFcn',  @StressTest_OutputFcn, ...
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


% --- Executes just before StressTest is made visible.
function StressTest_OpeningFcn(hObject, eventdata, handles, varargin)

% Choose default command line output for StressTest
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
    
  
end

close(h_wb);

if ~handles.instr.measure_dc1
    set(handles.editV1, 'enable', 'off');
    set(handles.editI1, 'enable', 'off');
    set(handles.editP1, 'enable', 'off');
end

if ~handles.instr.measure_dc2
    set(handles.editV2, 'enable', 'off');
    set(handles.editI2, 'enable', 'off');
    set(handles.editP2, 'enable', 'off');
end


axes(handles.ax1);
xlabel('Time [s]');
ylabel('I_1');


axes(handles.ax2);
xlabel('Time [s]');
ylabel('I_2');

% initiate save path
handles.SavePath = 'data/*.mat';



% Call for measurement if auto measurement is selected
if handles.SETUP.AUTO
    handles = buttonLoad_Callback(hObject, eventdata, handles);
    buttonStress_Callback(hObject, eventdata, handles);
    buttonExit_Callback(hObject, eventdata, handles)
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


% --- Outputs from this function are returned to the command line.
function varargout = StressTest_OutputFcn(hObject, eventdata, handles) 
try delete(hObject); end


function buttonStress_Callback(hObject, eventdata, handles)
    global STRESS_CANCEL;
    global STRESS_DATA;
    STRESS_CANCEL = 0;

    DATA = measureStress(handles);
    
    if ~isempty(DATA.I1) || ~isempty(DATA.I2)
        handles = saveStressData(DATA, handles);
        STRESS_DATA = DATA;
        set(handles.buttonSaveMAT, 'Enable', 'on');
    else
        set(handles.buttonStop, 'Enable', 'off');
        set(handles.buttonStress, 'Enable', 'on');
        set(handles.buttonSaveMAT, 'Enable', 'off');
    end
    
    
    
    
    % Update handles structure
    guidata(hObject, handles);
    
    

    
    
    
    
    
   
function DATA = measureStress(handles)

    global STRESS_CANCEL; %global variable for canceling measurement
    
    % Bias settling time
    if strcmp(handles.SETUP.MEASTYPE, 'DEMO')
        BIAS_SETTLE = 0;
    else
        BIAS_SETTLE = handles.SETUP.BIAS_SETTLE;       
    end
    

    try
           
       
        set(handles.buttonStop, 'Enable', 'on');
        set(handles.buttonStress, 'Enable', 'off');
       
        % resave measurement info
        DC1 = handles.instr.measure_dc1;
        DC2 = handles.instr.measure_dc2;

        BIAS.V1 = str2double(get(handles.editV1, 'String'));
        BIAS.V2 = str2double(get(handles.editV2, 'String'));
        BIAS.I1 = str2double(get(handles.editI1, 'String'));
        BIAS.I2 = str2double(get(handles.editI2, 'String'));
        BIAS.P1 = str2double(get(handles.editP1, 'String'));
        BIAS.P2 = str2double(get(handles.editP2, 'String'));
        INTERVAL = str2double(get(handles.editInterval, 'String'));
        STOP = str2double(get(handles.editStop, 'String'));
        
        DATA.V1 = [];
        DATA.V2 = [];
        DATA.I1 = [];
        DATA.I2 = [];
        DATA.TIME1 = [];
        DATA.TIME2 = [];
        DATA.BIAS.V1 = BIAS.V1;
        DATA.BIAS.V2 = BIAS.V2;
        DATA.BIAS.I1 = BIAS.I1;
        DATA.BIAS.I2 = BIAS.I2;
        DATA.BIAS.P1 = BIAS.P1;
        DATA.BIAS.P2 = BIAS.P2;
        DATA.INTERVAL = INTERVAL;
        DATA.STOP = STOP;
        
        
        
        
        % Set the current compliance if a power compliance is set
        if DC1 && ~isempty(BIAS.P1) && (BIAS.P1 > 0)
            BIAS.I1 = abs(BIAS.P1/BIAS.V1);
        end
        if DC2 && ~isempty(BIAS.P2) && (BIAS.P2 > 0)
            BIAS.I2 = abs(BIAS.P2/BIAS.V2);
        end   
        
        
        % Make sure that the current compliance is nonzero
        if DC1 && (isempty(BIAS.I1) || isequal(BIAS.I1, 0))
            errordlg('A compliance for V1 has to be set');
            throw();            
        end
        if DC2 && (isempty(BIAS.I2) || isequal(BIAS.I2, 0))
            errordlg('A compliance for V2 has to be set');
            throw();              
        end
        
        
        tic;

        while (toc < STOP) && ~STRESS_CANCEL

            if strcmp(handles.SETUP.MEASTYPE, 'DEMO')

                % Measure dummy measurement
                if DC1
                    MEAS.I1 = log(toc);
                    if MEAS.I1 > BIAS.I1
                        MEAS.I1 = BIAS.I1;
                    end
                    MEAS.TIME1 = toc;
                    MEAS.V1 = BIAS.V1+rand(1);
                end

                if DC2
                    MEAS.I2 = log10(toc);
                    if MEAS.I2 > BIAS.I2
                        MEAS.I2 = BIAS.I2;
                    end
                    MEAS.TIME2 = toc;
                    MEAS.V2 = BIAS.V2+rand(1);
                end


            else



                % set bias point and turn on bias
                if DC1
                    set(instr.dc1, 'Voltage', BIAS.V1);
                    set(instr.dc1, 'Current', BIAS.I1);
                    set(instr.dc1, 'Output', 1);
                end
                if DC2
                    set(instr.dc2, 'Voltage', BIAS.V2);
                    set(instr.dc2, 'Current', BIAS.I2);
                    set(instr.dc2, 'Output', 1);
                end

                % Pause
                pause(BIAS_SETTLE);

                % measure DC-bias
                if DC1
                    MEAS.I1 = invoke(instr.i1, 'MeasCurrent');
                    MEAS.V1 = invoke(instr.v1, 'MeasVoltage');
                    MEAS.TIME1 = toc;
                end

                if DC2
                    MEAS.I2 = invoke(instr.i2, 'MeasCurrent');
                    MEAS.V2 = invoke(instr.v2, 'MeasVoltage');
                    MEAS.TIME2 = toc;
                end

                % turn off-bias
                if DC2
                    set(instr.dc2, 'Output', 0);
                end
                if DC1
                    set(instr.dc1, 'Output', 0);
                end

            end
            
            
                        
            if DC1
                DATA.V1 = [DATA.V1, MEAS.V1];
                DATA.I1 = [DATA.I1, MEAS.I1];
                DATA.TIME1 = [DATA.TIME1, MEAS.TIME1];
                axes(handles.ax1);
                plot(DATA.TIME1, DATA.I1);                
                xlabel('Time [s]');
                ylabel('I_1 [A]');                
            end
            
            if DC2
                DATA.V2 = [DATA.V2, MEAS.V2];
                DATA.I2 = [DATA.I2, MEAS.I2];
                DATA.TIME2 = [DATA.TIME2, MEAS.TIME2];
                axes(handles.ax2);
                plot(DATA.TIME2, DATA.I2);
                xlabel('Time [s]');
                ylabel('I_2 [A]');
            end
            
            
            save('data/backup.mat','DATA'); % save a backup copy of the measurement
            
            % Make the interval pause, but reduce with the settling time so
            % that the total amount of time paused in the loop is equal to
            % the data.INTERVAL time
            pause(INTERVAL-BIAS_SETTLE);

        end
        
        
        
    end



function editV1_Callback(hObject, eventdata, handles)
function editV1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function editI1_Callback(hObject, eventdata, handles)
function editI1_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function editP1_Callback(hObject, eventdata, handles)
function editP1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function editV2_Callback(hObject, eventdata, handles)
function editV2_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function editI2_Callback(hObject, eventdata, handles)
function editI2_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function editP2_Callback(hObject, eventdata, handles)
function editP2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function editInterval_Callback(hObject, eventdata, handles)
function editInterval_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function editStop_Callback(hObject, eventdata, handles)
function editStop_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function handles = buttonLoad_Callback(hObject, eventdata, handles)
    try
        if handles.SETUP.AUTO
            load(handles.SETUP.BIASFILE);
        else
            [file,path] = uigetfile('setup/*.mat','Open setup file');
            load(fullfile(path,file)); 
        end
        
        set(handles.editV1, 'String', num2str(DATA.BIAS.V1));        
        set(handles.editV2, 'String', num2str(DATA.BIAS.V2));
        set(handles.editI1, 'String', num2str(DATA.BIAS.I1));
        set(handles.editI2, 'String', num2str(DATA.BIAS.I2));
        set(handles.editP1, 'String', num2str(DATA.BIAS.P1));
        set(handles.editP2, 'String', num2str(DATA.BIAS.P2));
        set(handles.editInterval, 'String', num2str(DATA.INTERVAL));
        set(handles.editStop, 'String', num2str(DATA.STOP));
        
    end
    
    % Update handles structure
    guidata(hObject, handles);
    




function buttonSave_Callback(hObject, eventdata, handles)
    DATA.BIAS.V1 = str2double(get(handles.editV1, 'String'));
    DATA.BIAS.V2 = str2double(get(handles.editV2, 'String'));
    DATA.BIAS.I1 = str2double(get(handles.editI1, 'String'));
    DATA.BIAS.I2 = str2double(get(handles.editI2, 'String'));
    DATA.BIAS.P1 = str2double(get(handles.editP1, 'String'));
    DATA.BIAS.P2 = str2double(get(handles.editP2, 'String'));
    DATA.INTERVAL = str2double(get(handles.editInterval, 'String'));
    DATA.STOP = str2double(get(handles.editStop, 'String'));
    DATA.MEAS = 'STRESS';
    
    % save the measurement
    [file,path] = uiputfile('setup/*.mat','Save setup');
    if ~isequal(path, 0)
        save(fullfile(path,file), 'DATA');
    end
    
    % Update handles structure
    guidata(hObject, handles);



function buttonSaveMAT_Callback(hObject, eventdata, handles)
    
    global STRESS_DATA;

    handles = saveStressData(STRESS_DATA, handles);
    
    % Update handles structure
    guidata(hObject, handles);



function buttonExit_Callback(hObject, eventdata, handles)
    if handles.SETUP.DEMO == 0
        instrreset;
    end
    uiresume(handles.figure);


% --- Executes on button press in buttonStop.
function buttonStop_Callback(hObject, eventdata, handles)
    global STRESS_CANCEL;
    STRESS_CANCEL = 1;
    
    
function handles = saveStressData(DATA, handles)

    global FILENAME;
    
    % disable stop button
    set(handles.buttonStop,'Enable','Off');
    
    if ~isempty(DATA)
    
        if handles.SETUP.AUTO
            try
                save(handles.SETUP.FILENAME, 'DATA');
            end
        else

            handles.SavePath = strrep(handles.SavePath, '*.mat', '');
            [file,path] = uiputfile({'*.*', 'No filetypes considered'},'Save measurement', handles.SavePath);
            FILENAME = file; 

            if ~isequal(path, 0) 
                handles.SavePath = path;
                save(fullfile(path,file), 'DATA');
            end

        end

    end
    
    set(handles.buttonStress,'Enable','On'); % enable measure button
   
        
        
        
       


% --- Executes on button press in buttonLoadMAT.
function buttonLoadMAT_Callback(hObject, eventdata, handles)
    global STRESS_DATA;
    
    [FileName,PathName] =... 
        uigetfile({'*.mat', 'MAT-files'}, 'Open data file' ,handles.SavePath);
        
    try load([PathName, FileName])
        
        
        
        
        set(handles.editV1, 'String', num2str(DATA.BIAS.V1));        
        set(handles.editV2, 'String', num2str(DATA.BIAS.V2));
        set(handles.editI1, 'String', num2str(DATA.BIAS.I1));
        set(handles.editI2, 'String', num2str(DATA.BIAS.I2));
        set(handles.editP1, 'String', num2str(DATA.BIAS.P1));
        set(handles.editP2, 'String', num2str(DATA.BIAS.P2));
        set(handles.editInterval, 'String', num2str(DATA.INTERVAL));
        set(handles.editStop, 'String', num2str(DATA.STOP));
        
        if handles.instr.measure_dc1
            axes(handles.ax1);
            plot(DATA.TIME1, DATA.I1);
            xlabel('Time [s]');
            ylabel('I_1 [A]');
        end
        
        if handles.instr.measure_dc2
            axes(handles.ax2);
            plot(DATA.TIME2, DATA.I2);  
            xlabel('Time [s]');
            ylabel('I_2 [A]');            
        end        
        
    end
    
    
    
    
    
    
    
    
