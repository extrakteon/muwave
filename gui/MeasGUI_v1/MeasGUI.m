function varargout = MeasGUI(varargin)
% MEASGUI M-file for MeasGUI.fig
%      MEASGUI, by itself, creates a new MEASGUI or raises the existing
%      singleton*.
%
%      H = MEASGUI returns the handle to a new MEASGUI or the handle to
%      the existing singleton*.
%
%      MEASGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MEASGUI.M with the given input arguments.
%
%      MEASGUI('Property','Value',...) creates a new MEASGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MeasGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MeasGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MeasGUI

% Last Modified by GUIDE v2.5 03-Aug-2011 14:39:39

% Initialization added by Mattias Ferndahl. 
if isempty(dir('data')) % check if default save folder: data/ exist:
    mkdir('data');      % create data/ if not
end

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MeasGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @MeasGUI_OutputFcn, ...
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


function MeasGUI_OpeningFcn(hObject, eventdata, handles, varargin)
    clc;

    instrreset;

    % Choose default command line output for MeasGUI
    handles.output = hObject;

    % Update handles structure
    guidata(hObject, handles);

    % set path
    path(path,'code');
    path(path, 'drivers');

    % load default settings
    try
        handles.SETUP = DEFAULT_SETTINGS();
        guidata(hObject,handles); % save updated SETUP
    catch ERR
        disp('DEFAULT_SETTINGS.m is not existing.');  
    end

    %load chalmers logo
    % [logo logomap] = imread('logo_svart.bmp');
    % axes(handles.logo);
    % imshow(logo);
    % colormap(logomap);

    logoIm = importdata('logo_svart.bmp');
    %set the image as the button background
    set(handles.logo,'CDATA',logoIm);

    % UIWAIT makes MeasGUI wait for user response (see UIRESUME)
    uiwait(handles.figure);

function varargout = MeasGUI_OutputFcn(hObject, eventdata, handles) 
    % Get default command line output from handles structure
    instrreset;
    % unloadlibrary('lsnaapi');
    delete(hObject);                                        


function dc_meas_1_Callback(hObject, eventdata, handles)
    contents = get(hObject,'String');

    if strcmp(contents{get(hObject,'Value')},'none')
        set(handles.dc_meas_1_gpib,'Enable','off');
    else
        set(handles.dc_meas_1_gpib,'Enable','on');
    end
function dc_meas_1_CreateFcn(hObject, eventdata, handles)
function dc_meas_1_gpib_CreateFcn(hObject, eventdata, handles)
function dc_meas_2_gpib_CreateFcn(hObject, eventdata, handles)
function dc_meas_2_CreateFcn(hObject, eventdata, handles)
function dc_meas_1_gpib_Callback(hObject, eventdata, handles)
function dc_meas_2_Callback(hObject, eventdata, handles)
    contents = get(hObject,'String');

    if strcmp(contents{get(hObject,'Value')},'none')
        set(handles.dc_meas_2_gpib,'Enable','off');
    else
        set(handles.dc_meas_2_gpib,'Enable','on');
    end
function dc_meas_2_gpib_Callback(hObject, eventdata, handles)
function dc_1_Callback(hObject, eventdata, handles)
    contents = get(hObject,'String');

    if strcmp(contents{get(hObject,'Value')},'none')
        set(handles.dc_1_gpib,'Enable','off');
        set(handles.dc_1_channel,'Enable','off');
        set(handles.dc_meas_1, 'Enable', 'on');
        set(handles.dc_meas_1, 'Value', 1);
        set(handles.dc_meas_1_gpib, 'Enable', 'off');
    else
        if strcmp(strtrim(contents{get(hObject,'Value')}),'Agilent 4156')
            set(handles.dc_meas_1, 'Enable', 'off');
            set(handles.dc_meas_1, 'Value', 2);
            set(handles.dc_meas_1_gpib,'Enable','on');
        else
            set(handles.dc_meas_1, 'Enable', 'on');
            set(handles.dc_meas_1, 'Value', 1);
        end
        set(handles.dc_1_gpib,'Enable','on');
        set(handles.dc_1_channel,'Enable','on');
    end
function dc_1_CreateFcn(hObject, eventdata, handles)
function dc_2_Callback(hObject, eventdata, handles)
    contents = get(hObject,'String');

    if strcmp(contents{get(hObject,'Value')},'none')
        set(handles.dc_2_gpib,'Enable','off');
        set(handles.dc_2_channel,'Enable','off');
        set(handles.dc_meas_2, 'Value', 1);
        set(handles.dc_meas_2, 'Enable', 'on');
        set(handles.dc_meas_2_gpib, 'Enable', 'off');

    else
        if strcmp(strtrim(contents{get(hObject,'Value')}),'Agilent 4156')
            set(handles.dc_meas_2, 'Value', 2);
            set(handles.dc_meas_2, 'Enable', 'off');
            set(handles.dc_meas_2_gpib,'Enable','on');
        else
            set(handles.dc_meas_2, 'Value', 1);
            set(handles.dc_meas_2, 'Enable', 'on');
        end
        set(handles.dc_2_gpib,'Enable','on');
        set(handles.dc_2_channel,'Enable','on');
    end
function dc_2_CreateFcn(hObject, eventdata, handles)
function dc_1_gpib_Callback(hObject, eventdata, handles)
function dc_1_gpib_CreateFcn(hObject, eventdata, handles)
function dc_2_gpib_Callback(hObject, eventdata, handles)
function dc_2_gpib_CreateFcn(hObject, eventdata, handles)
function dc_1_channel_Callback(hObject, eventdata, handles)
function dc_1_channel_CreateFcn(hObject, eventdata, handles)
function dc_2_channel_Callback(hObject, eventdata, handles)
function dc_2_channel_CreateFcn(hObject, eventdata, handles)

    
    
function vna_Callback(hObject, eventdata, handles)
    contents = get(hObject,'String'); % returns vna contents as cell array
    vna_sel = contents{get(hObject,'Value')}; % returns selected item from vna

    if strcmp(vna_sel,'Maury/NMDG LSNA')
        set(handles.synt,'Enable','on');
        set(handles.synt_gpib,'Enable','on');
    else
        set(handles.synt,'Enable','off');
        set(handles.synt_gpib,'Enable','off');    
    end

    if strcmp(vna_sel,'none')
        set(handles.SPmeas, 'Enable', 'off');
        set(handles.vna_gpib, 'Enable', 'off');
    else
        set(handles.SPmeas, 'Enable', 'on');
        set(handles.vna_gpib, 'Enable', 'on');
    end
function vna_CreateFcn(hObject, eventdata, handles)
function vna_gpib_Callback(hObject, eventdata, handles)
function vna_gpib_CreateFcn(hObject, eventdata, handles)
    
    
function save_Callback(hObject, eventdata, handles)
    SETUP = handles.SETUP; % save settings
    config.demo = get(handles.demo,'Value');

    config.vs1_idx = get(handles.dc_1,'Value'); % get the chosen index
    config.vs1_gpib = get(handles.dc_1_gpib,'String'); % get gpib
    config.vs1_channel =  get(handles.dc_1_channel,'String'); % get channel
    config.vs2_idx = get(handles.dc_2,'Value'); % get the chosen index
    config.vs2_gpib = get(handles.dc_2_gpib,'String'); % get gpib
    config.vs2_channel =  get(handles.dc_2_channel,'String'); % get channel
    config.cm1_idx = get(handles.dc_meas_1,'Value'); % get the chosen index
    config.cm1_gpib = get(handles.dc_meas_1_gpib,'String'); % get gpib
    config.cm2_idx = get(handles.dc_meas_2,'Value'); % get the chosen index
    config.cm2_gpib = get(handles.dc_meas_2_gpib,'String'); % get gpib
    config.vna_idx = get(handles.vna,'Value'); % get the chosen index
    config.vna_gpib = get(handles.vna_gpib,'String'); % get gpib
    config.synt_idx = get(handles.synt,'Value'); % get the chosen index
    config.synt_gpib = get(handles.synt_gpib,'String'); % get gpib

    % save the configuration
    [file,path] = uiputfile('config/*.mat','Save configuration');

    if ~isequal(path, 0)
        save(fullfile(path,file), 'config', 'SETUP');
    end
function load_Callback(hObject, eventdata, handles)
    try
        % load file
        if handles.SETUP.AUTO
            load(handles.SETUP.CONFIGFILE);
            SETUP.CONFIGFILE = handles.SETUP.CONFIGFILE;
            SETUP.BIASFILE = handles.SETUP.BIASFILE;
            
        else
            [file,path] = uigetfile('config/*.mat','Open configuration file');
            load(fullfile(path,file));
        end
    
    
        

        handles.SETUP = SETUP;
        set(handles.demo,'Value',config.demo);
        guidata(hObject,handles); % save updated SETUP

        % update instrument information
        set(handles.dc_1,'Value',config.vs1_idx); % set index
        set(handles.dc_1_gpib,'String',config.vs1_gpib); % set gpib
        set(handles.dc_1_channel,'String',config.vs1_channel); % set channel
        set(handles.dc_2,'Value',config.vs2_idx); % set index
        set(handles.dc_2_gpib,'String',config.vs2_gpib); % set gpib
        set(handles.dc_2_channel,'String',config.vs2_channel); % set channel
        set(handles.dc_meas_1,'Value',config.cm1_idx); % set index
        set(handles.dc_meas_1_gpib,'String',config.cm1_gpib); % set gpib
        set(handles.dc_meas_2,'Value',config.cm2_idx); % set index
        set(handles.dc_meas_2_gpib,'String',config.cm2_gpib); % set gpib
        set(handles.vna,'Value',config.vna_idx); % set index
        set(handles.vna_gpib,'String',config.vna_gpib); % set gpib
        set(handles.synt,'Value',config.synt_idx); % set index
        set(handles.synt_gpib,'String',config.synt_gpib); % set gpib


        % enable all GPIB and VNA boxes
        set(handles.dc_1_gpib,'Enable','on'); % set gpib
        set(handles.dc_1_channel,'Enable','on'); % set channel
        set(handles.dc_2_gpib,'Enable','on'); % set gpib
        set(handles.dc_2_channel,'Enable','on'); % set channel
        set(handles.dc_meas_1_gpib,'Enable','on'); % set gpib
        set(handles.dc_meas_2_gpib,'Enable','on'); % set gpib
        set(handles.vna_gpib,'Enable','on'); % set gpib


        % Check if LSNA is selected
        contents = get(handles.vna,'String'); % returns vna contents as cell array
        vna_sel = contents{config.vna_idx}; % returns selected item from vna
        if strcmp(vna_sel,'Maury/NMDG LSNA')
            set(handles.synt,'Enable','on');
            set(handles.synt_gpib,'Enable','on');
        else
            set(handles.synt,'Enable','off');
            set(handles.synt_gpib,'Enable','off');
        end
    end
    
function synt_Callback(hObject, eventdata, handles)
function synt_CreateFcn(hObject, eventdata, handles)
function synt_gpib_Callback(hObject, eventdata, handles)
function synt_gpib_CreateFcn(hObject, eventdata, handles)
function figure_CreateFcn(hObject, eventdata, handles)



function IVmeas_Callback(hObject, eventdata, handles)
    % check demo mode
    handles.SETUP.DEMO = get(handles.demo,'Value');

    % read out the chosen instrument configurations
    idx = get(handles.dc_1,'Value'); % get the chosen index
    TmpStr = get(handles.dc_1,'String'); % readout all instruments
    instruments.dc1 = TmpStr(idx); % select the chosen instrument
    instruments.dc1_gpib = str2double(get(handles.dc_1_gpib,'String'));
    instruments.dc1_channel = str2double(get(handles.dc_1_channel,'String'));

    idx = get(handles.dc_2,'Value'); % get the chosen index
    TmpStr = get(handles.dc_2,'String'); % readout all instruments
    instruments.dc2 = TmpStr(idx); % select the chosen instrument
    instruments.dc2_gpib = str2double(get(handles.dc_2_gpib,'String'));
    instruments.dc2_channel = str2double(get(handles.dc_2_channel,'String'));

    idx = get(handles.dc_meas_1,'Value'); % get the chosen index
    TmpStr = get(handles.dc_meas_1,'String'); % readout all instruments
    instruments.dcmeas1 = TmpStr(idx); % select the chosen instrument
    instruments.dcmeas1_gpib = str2double(get(handles.dc_meas_1_gpib,'String'));

    idx = get(handles.dc_meas_2,'Value'); % get the chosen index
    TmpStr = get(handles.dc_meas_2,'String'); % readout all instruments
    instruments.dcmeas2 = TmpStr(idx); % select the chosen instrument
    instruments.dcmeas2_gpib = str2double(get(handles.dc_meas_2_gpib,'String'));

    idx = get(handles.vna,'Value'); % get the chosen index
    TmpStr = get(handles.vna,'String'); % readout all instruments
    instruments.vna = TmpStr(idx); % select the chosen instrument
    instruments.vna_gpib = str2double(get(handles.vna_gpib,'String'));

    instruments.synt_gpib = str2double(get(handles.synt_gpib,'String'));
    instruments.ao = handles.SETUP.NUMATT;
    instruments.dio = handles.SETUP.NUMMOD;

    if strcmp(instruments.dc1, 'Agilent 4156')
        instruments.dc1 = {'Agilent 4156 Analyzer'};
        instruments.vna = {'none'};

        if ~strcmp(instruments.dc2, 'Agilent 4156')
            instruments.dc2 = {'none'};
        end
    end

    if strcmp(instruments.dc2, 'Agilent 4156')
        instruments.dc2 = {'Agilent 4156 Analyzer'};
        instruments.vna = {'none'};

        if ~strcmp(instruments.dc1, 'Agilent 4156 Analyzer')
            instruments.dc1 = {'none'};
        end

    end


    % Measure
    h_wb = waitbar(0, 'Initializing instruments. Please wait.');
    MeasIV(instruments,handles.SETUP,h_wb);

function SPmeas_Callback(hObject, eventdata, handles)

    % check demo mode
    handles.SETUP.DEMO = get(handles.demo,'Value');

    % read out the chosen instrument configurations
    idx = get(handles.dc_1,'Value'); % get the chosen index
    TmpStr = get(handles.dc_1,'String'); % readout all instruments
    instruments.dc1 = TmpStr(idx); % select the chosen instrument
    instruments.dc1_gpib = str2double(get(handles.dc_1_gpib,'String'));
    instruments.dc1_channel = str2double(get(handles.dc_1_channel,'String'));

    idx = get(handles.dc_2,'Value'); % get the chosen index
    TmpStr = get(handles.dc_2,'String'); % readout all instruments
    instruments.dc2 = TmpStr(idx); % select the chosen instrument
    instruments.dc2_gpib = str2double(get(handles.dc_2_gpib,'String'));
    instruments.dc2_channel = str2double(get(handles.dc_2_channel,'String'));

    idx = get(handles.dc_meas_1,'Value'); % get the chosen index
    TmpStr = get(handles.dc_meas_1,'String'); % readout all instruments
    instruments.dcmeas1 = TmpStr(idx); % select the chosen instrument
    instruments.dcmeas1_gpib = str2double(get(handles.dc_meas_1_gpib,'String'));

    idx = get(handles.dc_meas_2,'Value'); % get the chosen index
    TmpStr = get(handles.dc_meas_2,'String'); % readout all instruments
    instruments.dcmeas2 = TmpStr(idx); % select the chosen instrument
    instruments.dcmeas2_gpib = str2double(get(handles.dc_meas_2_gpib,'String'));

    idx = get(handles.vna,'Value'); % get the chosen index
    TmpStr = get(handles.vna,'String'); % readout all instruments
    instruments.vna = TmpStr(idx); % select the chosen instrument
    instruments.vna_gpib = str2double(get(handles.vna_gpib,'String'));

    instruments.synt_gpib = str2double(get(handles.synt_gpib,'String'));
    instruments.ao = handles.SETUP.NUMATT;
    instruments.dio = handles.SETUP.NUMMOD;

    if strcmp(instruments.dc1, 'Agilent 4156')
        instruments.dc1 = {'Agilent 4156 DC'};
    end

    if strcmp(instruments.dc2, 'Agilent 4156')
        instruments.dc2 = {'Agilent 4156 DC'};
    end


    if handles.SETUP.DEMO
        % Measure
        h_wb = waitbar(0, 'Initializing instruments. Please wait.');
        MeasSP(instruments,handles.SETUP,h_wb);
    else
        switch char(instruments.vna)
            case {'none','Maury/NMDG LSNA'}
                msgbox('Pleas chose a VNA for S-parameter measurement.',...
                    'Error','error');
            otherwise
                % Measure
                h_wb = waitbar(0, 'Initializing instruments. Please wait.');
                MeasSP(instruments,handles.SETUP,h_wb);
        end
    end

function LSNAmeas_Callback(hObject, eventdata, handles)
    % check demo mode
    handles.SETUP.DEMO = get(handles.demo,'Value');

    idx = get(handles.dc_1,'Value'); % get the chosen index
    TmpStr = get(handles.dc_1,'String'); % readout all instruments
    instruments.dc1 = TmpStr(idx); % select the chosen instrument
    instruments.dc1_gpib = str2double(get(handles.dc_1_gpib,'String'));
    instruments.dc1_channel = str2double(get(handles.dc_1_channel,'String'));

    idx = get(handles.dc_2,'Value'); % get the chosen index
    TmpStr = get(handles.dc_2,'String'); % readout all instruments
    instruments.dc2 = TmpStr(idx); % select the chosen instrument
    instruments.dc2_gpib = str2double(get(handles.dc_2_gpib,'String'));
    instruments.dc2_channel = str2double(get(handles.dc_2_channel,'String'));

    idx = get(handles.dc_meas_1,'Value'); % get the chosen index
    TmpStr = get(handles.dc_meas_1,'String'); % readout all instruments
    instruments.dcmeas1 = TmpStr(idx); % select the chosen instrument
    instruments.dcmeas1_gpib = str2double(get(handles.dc_meas_1_gpib,'String'));

    idx = get(handles.dc_meas_2,'Value'); % get the chosen index
    TmpStr = get(handles.dc_meas_2,'String'); % readout all instruments
    instruments.dcmeas2 = TmpStr(idx); % select the chosen instrument
    instruments.dcmeas2_gpib = str2double(get(handles.dc_meas_2_gpib,'String'));

    idx = get(handles.vna,'Value'); % get the chosen index
    TmpStr = get(handles.vna,'String'); % readout all instruments
    instruments.vna = TmpStr(idx); % select the chosen instrument
    instruments.vna_gpib = str2double(get(handles.vna_gpib,'String'));

    instruments.synt_gpib = str2double(get(handles.synt_gpib,'String'));
    instruments.ao = handles.SETUP.NUMATT;
    instruments.dio = handles.SETUP.NUMMOD;

    if handles.SETUP.DEMO
        % Measure
        h_wb = waitbar(0, 'Initializing instruments. Please wait.');
        MeasLSNA(instruments,handles.SETUP,h_wb);
    else
        switch char(instruments.vna)
            case {'Maury/NMDG LSNA'}
                % Measure
                h_wb = waitbar(0, 'Initializing instruments. Please wait.');
                MeasLSNA(instruments,handles.SETUP,h_wb);            
            otherwise
                msgbox('Pleas chose Maury/NMDG LSNA for LSNA measurement.',...
                    'Error','error');
        end
    end

function buttonStress_Callback(hObject, eventdata, handles)
% check demo mode
    handles.SETUP.DEMO = get(handles.demo,'Value');

    % read out the chosen instrument configurations
    idx = get(handles.dc_1,'Value'); % get the chosen index
    TmpStr = get(handles.dc_1,'String'); % readout all instruments
    instruments.dc1 = TmpStr(idx); % select the chosen instrument
    instruments.dc1_gpib = str2double(get(handles.dc_1_gpib,'String'));
    instruments.dc1_channel = str2double(get(handles.dc_1_channel,'String'));

    idx = get(handles.dc_2,'Value'); % get the chosen index
    TmpStr = get(handles.dc_2,'String'); % readout all instruments
    instruments.dc2 = TmpStr(idx); % select the chosen instrument
    instruments.dc2_gpib = str2double(get(handles.dc_2_gpib,'String'));
    instruments.dc2_channel = str2double(get(handles.dc_2_channel,'String'));

    idx = get(handles.dc_meas_1,'Value'); % get the chosen index
    TmpStr = get(handles.dc_meas_1,'String'); % readout all instruments
    instruments.dcmeas1 = TmpStr(idx); % select the chosen instrument
    instruments.dcmeas1_gpib = str2double(get(handles.dc_meas_1_gpib,'String'));

    idx = get(handles.dc_meas_2,'Value'); % get the chosen index
    TmpStr = get(handles.dc_meas_2,'String'); % readout all instruments
    instruments.dcmeas2 = TmpStr(idx); % select the chosen instrument
    instruments.dcmeas2_gpib = str2double(get(handles.dc_meas_2_gpib,'String'));

    idx = get(handles.vna,'Value'); % get the chosen index
    TmpStr = get(handles.vna,'String'); % readout all instruments
    instruments.vna = TmpStr(idx); % select the chosen instrument
    instruments.vna_gpib = str2double(get(handles.vna_gpib,'String'));

    instruments.synt_gpib = str2double(get(handles.synt_gpib,'String'));
    instruments.ao = handles.SETUP.NUMATT;
    instruments.dio = handles.SETUP.NUMMOD;

    if strcmp(instruments.dc1, 'Agilent 4156')
        instruments.dc1 = {'Agilent 4156 Analyzer'};
        instruments.vna = {'none'};

        if ~strcmp(instruments.dc2, 'Agilent 4156')
            instruments.dc2 = {'none'};
        end
    end

    if strcmp(instruments.dc2, 'Agilent 4156')
        instruments.dc2 = {'Agilent 4156 Analyzer'};
        instruments.vna = {'none'};

        if ~strcmp(instruments.dc1, 'Agilent 4156 Analyzer')
            instruments.dc1 = {'none'};
        end

    end


    % Measure
    h_wb = waitbar(0, 'Initializing instruments. Please wait.');
    StressTest(instruments,handles.SETUP,h_wb);

function settings_Callback(hObject, eventdata, handles)
    SETUP = Settings(handles.SETUP);
    handles.SETUP = SETUP;
    guidata(hObject,handles); % save updated SETUP

    
    
function logoax_CreateFcn(hObject, eventdata, handles)
function exit_Callback(hObject, eventdata, handles)
    uiresume(handles.figure);
function demo_Callback(hObject, eventdata, handles)
function figure_CloseRequestFcn(hObject, eventdata, handles)
    uiresume(handles.figure);
function logo_Callback(hObject, eventdata, handles)


function buttonAUTO_Callback(hObject, eventdata, handles)
    
    handles.SETUP.AUTO = 1;
    
    
    try
    
        
        if ~isempty(get(handles.editPath, 'String'))

            % Opens the file given and separate the diffrerent files
            fID = fopen(get(handles.editPath, 'String'), 'r');
            files = textscan(fID, '%s %s %s', 'delimiter', ':');
            fclose(fID);

            config = files{1};
            setup = files{2};
            file = files{3};
            
            if ~isequal(length(config), length(setup), length(file))
                errordlg('Every measurement must contain three arguments');
            else
                
                nbrOfMeas = length(config);
                
                for idx = 1:nbrOfMeas
                    
                    % Save the specific filenames so that they can be used
                    % later on
                    handles.SETUP.CONFIGFILE =...
                        ['config\' strrep(config{idx}, '.mat', ''), '.mat'];        
                    handles.SETUP.BIASFILE =...
                        ['setup\' strrep(setup{idx}, '.mat', ''), '.mat'];
                    handles.SETUP.FILENAME =...
                        ['data\', strrep(file{idx}, '.mat', ''), '.mat'];

                    % Loads the config file
                    load_Callback(hObject, eventdata, handles);
                    
                    % Import the bias setup file and determine if IV or SP
                    % meas is called
                    load(handles.SETUP.BIASFILE);
                    if isequal(DATA.MEAS, 'IV')
                        IVmeas_Callback(hObject, eventdata, handles);
                    elseif isequal(DATA.MEAS, 'SP')                   
                        SPmeas_Callback(hObject, eventdata, handles);
                    elseif isequal(DATA.MEAS, 'STRESS')
                        buttonStress_Callback(hObject, eventdata, handles);
                    end
                    
                end
            
            end
            
        end
    
    end
    
    handles.SETUP.AUTO = 0;
    
    % Update handles structure
    guidata(hObject, handles);
function editPath_Callback(hObject, eventdata, handles)   
function buttonBrowse_Callback(hObject, eventdata, handles)
    [file,path] = uigetfile({'*.txt',...
        'Tab delimited instruction file (*.txt)'},'Import instruction file');
    
    if ~isequal(path, 0)
        set(handles.editPath, 'String', [path, file]);
    end
function editPath_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'),...
        get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
