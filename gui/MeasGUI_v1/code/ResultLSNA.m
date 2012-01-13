function varargout = ResultLSNA(varargin)
% RESULTLSNA M-file for ResultLSNA.fig
%      RESULTLSNA, by itself, creates a new RESULTLSNA or raises the existing
%      singleton*.
%
%      H = RESULTLSNA returns the handle to a new RESULTLSNA or the handle to
%      the existing singleton*.
%
%      RESULTLSNA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RESULTLSNA.M with the given input arguments.
%
%      RESULTLSNA('Property','Value',...) creates a new RESULTLSNA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ResultLSNA_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ResultLSNA_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ResultLSNA

% Last Modified by GUIDE v2.5 19-Aug-2009 09:18:05

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ResultLSNA_OpeningFcn, ...
                   'gui_OutputFcn',  @ResultLSNA_OutputFcn, ...
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

function ResultLSNA_OpeningFcn(hObject, eventdata, handles, varargin)
% Choose default command line output for ResultLSNA
handles.output = hObject;

% get parent information
handles.measlsna = varargin{1};

% get measurement info
InData = varargin{2};

% resave MeasLSNA data
DEMO = handles.measlsna.SETUP.DEMO;
MEASTYPE = handles.measlsna.SETUP.MEASTYPE;

if DEMO == 0
    handles.BIAS = InData.BIAS;
    handles.PIN = InData.PIN;
    if strcmp(MEASTYPE,'ACTIVELP') || strcmp(MEASTYPE,'ACTIVELP_ATT')
        handles.GL = InData.GL;
    end
    handles.SETUP = InData.SETUP;
    handles.instr = InData.instr; 
    handles.DEMO = 0;
else
    load('Lg025_Vd20_LP2');
    handles.swp = data;
    clear cdata data;
    handles.BIAS = BIAS;
    handles.BIAS.NUMPOINTS = length(BIAS.V1);
    handles.PIN = PIN.Fund;
    handles.GL = GL;
    handles.DEMO = 1;
    handles.SETUP = InData.SETUP;
end

% initiate save path
handles.SavePath = handles.measlsna.SavePath;

% number of bias points
NBIAS = handles.BIAS.NUMPOINTS;

% number of input powers
NPWR = length(handles.PIN);

switch MEASTYPE
    case {'ACTIVELP','ACTIVELP_ATT','DEMO'}
        % number of gammaL
        [HARM NGL] = size(handles.GL);
    otherwise
        HARM = 1;
        NGL = 1;
        handles.GL = 0;
end

% number of measurements
NMEAS = NBIAS*NPWR*NGL;

% update measurement info
countstr = sprintf('Point %d out of %d', 0, NMEAS);
set(handles.countertext,'String',countstr);

% Smithchart initialization
init_smith(handles.smith);

% plot GL 
plot(real(handles.GL(1,:)),imag(handles.GL(1,:)),'.','Color',[0.7 0.1 0]);
if HARM == 2
    plot(real(handles.GL(2,:)),imag(handles.GL(2,:)),'s','Color',[0.7 0.1 0]);
end
plot(0,0,'s','Color',[0.15 0.45 0.15]);
plot(0,0,'o','Color',[0.15 0.2 0.8],'MarkerSize',8,'LineWidth',2);
plot(0,0,'.','Color',[0.15 0.45 0.15]);

h = get(handles.smith, 'Children');

% clear smithchart
set(h(1:3),'UserData',[]);
set(h(1:3),'XData',[]);
set(h(1:3),'YData',[]);

% set axes labels
axes(handles.ax1);
xlabel('V_1 [V]');
ylabel('I_1 [A]');
axes(handles.ax2);
xlabel('V_2 [V]');
ylabel('I_2 [A]');
axes(handles.ax3);
xlabel('P_I_N [dBm]');
ylabel('P_O_U_T [dBm]');
axes(handles.ax4);
xlabel('P_I_N [dBm]');
ylabel('\eta [%]');

% set MeasDone to false
handles.MeasDone = false;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ResultLSNA wait for user response (see UIRESUME)
uiwait(handles.figure);


function varargout = ResultLSNA_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.SavePath;
delete(hObject);


function start_Callback(hObject, eventdata, handles)
set(handles.start,'Enable','Off'); % disable start button
set(handles.stop,'Enable','On'); % enable stop button
global MEAS_CANCEL;
MEAS_CANCEL = false; % initiate stop button

if handles.measlsna.SETUP.DEMO == 0
    [swp data] = MeasureLSNA_New(handles);
else
    [swp data] = MeasureLSNA_dummyNew(handles);
end

set(handles.stop,'Enable','Off'); % disable stop button

% select last measured point
h = get(handles.smith, 'Children');
set(h(2),'UserData',length(data.GL));
set(h(2),'XData',real(data.GL(end)));
set(h(2),'YData',imag(data.GL(end)));

axes(handles.ax3);
hold on;
plot(data.Pin(end),data.Pout(end),'o','Color',[0.15 0.2 0.8],'MarkerSize',8,'LineWidth',2);
axes(handles.ax4);
hold on;
plot(data.Pin(end),data.Deff(end),'o','Color',[0.15 0.2 0.8],'MarkerSize',8,'LineWidth',2);

% update waveforms
axes(handles.ax1);
plot(swp(end).v1,swp(end).i1,'-k','LineWidth',2);
xlabel('V_1 [V]');
ylabel('I_1 [A]');
axes(handles.ax2);
plot(swp(end).v2,swp(end).i2,'-k','LineWidth',2);
xlabel('V_2 [V]');
ylabel('I_2 [A]');

% set MeasDone to true
handles.MeasDone = true;

% save swp in handles struct
handles.swp = swp;

% save data in handles struct
handles.data = data;

% save the measurement
[file,path] = uiputfile(handles.SavePath,'Save measurement');
save(fullfile(path,file), 'swp');

if path ~= 0
    handles.SavePath = [path '*.mat'];
end

% Update handles structure
guidata(hObject, handles);   

function stop_Callback(hObject, eventdata, handles)
global MEAS_CANCEL;
MEAS_CANCEL = true; % cancel measurement


function mv1_Callback(hObject, eventdata, handles)
function mv1_CreateFcn(hObject, eventdata, handles)
function mi1_Callback(hObject, eventdata, handles)
function mi1_CreateFcn(hObject, eventdata, handles)
function mv2_Callback(hObject, eventdata, handles)
function mv2_CreateFcn(hObject, eventdata, handles)
function mi2_Callback(hObject, eventdata, handles)
function mi2_CreateFcn(hObject, eventdata, handles)
function mpout_Callback(hObject, eventdata, handles)
function mpout_CreateFcn(hObject, eventdata, handles)
function mgt_Callback(hObject, eventdata, handles)
function mgt_CreateFcn(hObject, eventdata, handles)
function mgp_Callback(hObject, eventdata, handles)
function mgp_CreateFcn(hObject, eventdata, handles)
function mdeff_Callback(hObject, eventdata, handles)
function mdeff_CreateFcn(hObject, eventdata, handles)
function ax3_CreateFcn(hObject, eventdata, handles)


function close_Callback(hObject, eventdata, handles)
uiresume(handles.figure);

function figure_CloseRequestFcn(hObject, eventdata, handles)
uiresume(handles.figure);


function smith_ButtonDownFcn(hObject, eventdata, handles)


function figure_WindowButtonDownFcn(hObject, eventdata, handles)
PointSelection(handles);

