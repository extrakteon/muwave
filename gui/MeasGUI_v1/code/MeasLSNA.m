function varargout = MeasLSNA(varargin)
% MEASLSNA M-file for MeasLSNA.fig
%      MEASLSNA, by itself, creates a new MEASLSNA or raises the existing
%      singleton*.
%
%      H = MEASLSNA returns the handle to a new MEASLSNA or the handle to
%      the existing singleton*.
%
%      MEASLSNA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MEASLSNA.M with the given input arguments.
%
%      MEASLSNA('Property','Value',...) creates a new MEASLSNA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MeasLSNA_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MeasLSNA_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MeasLSNA

% Last Modified by GUIDE v2.5 19-Aug-2009 09:11:58

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MeasLSNA_OpeningFcn, ...
                   'gui_OutputFcn',  @MeasLSNA_OutputFcn, ...
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


function MeasLSNA_OpeningFcn(hObject, eventdata, handles, varargin)
% Choose default command line output for MeasLSNA
handles.output = hObject;

% get instrument information
instruments = varargin{1};

% get settings
handles.SETUP = varargin{2};

% initiate instruments
h_wb = varargin{3};
if handles.SETUP.DEMO
	% DEMO measurement
    set(handles.powercal,'Enable','Off');
    handles.SETUP.MEASTYPE = 'DEMO';
    handles.instr.measure_dc1 = 0;
    handles.instr.measure_dc2 = 0;
elseif (handles.SETUP.NUMMOD == 0) && (handles.SETUP.NUMATT == 1)
    % standard LSNA measurement, power sweep using attenuator
    handles.SETUP.MEASTYPE = 'PWRSWP_ATT';
    set(handles.selfund,'Enable','Off');
    set(handles.selharm,'Enable','Off');
    set(handles.setgrid,'Enable','Off');
    set(handles.AddRegion,'Enable','Off');
    set(handles.cleargamma,'Enable','Off');
    handles.instr = init_instr(instruments,h_wb);
elseif (handles.SETUP.NUMMOD == 0) && (handles.SETUP.NUMATT == 0)
    % standard LSNA measurement, power sweep using synthesizer
    handles.SETUP.MEASTYPE = 'PWRSWP';
    set(handles.powercal,'Enable','Off');
    set(handles.selfund,'Enable','Off');
    set(handles.selharm,'Enable','Off');
    set(handles.setgrid,'Enable','Off');
    set(handles.AddRegion,'Enable','Off');
    set(handles.cleargamma,'Enable','Off');
    handles.instr = init_instr(instruments,h_wb);
elseif (handles.SETUP.NUMMOD > 0) && (handles.SETUP.NUMATT == 0)
    % active load pull measurement without voltage controlled attenuators
    handles.SETUP.MEASTYPE = 'ACTIVELP';
    set(handles.powercal,'Enable','Off');
    handles.instr = init_instr(instruments,h_wb);
else
    % active load pull measurement using voltage controlled attenuators
    handles.SETUP.MEASTYPE = 'ACTIVELP_ATT';    
    handles.instr = init_instr(instruments,h_wb);
end

% check number of bias supplies
if ~handles.instr.measure_dc1 && ~handles.SETUP.DEMO % disable bias 1
    set(handles.v1start,'Enable','Off');
    set(handles.v1stop,'Enable','Off');
    set(handles.v1step,'Enable','Off');
    set(handles.i1comp,'Enable','Off');
    set(handles.p1comp,'Enable','Off');
end
if ~handles.instr.measure_dc2 && ~handles.SETUP.DEMO % disable bias 2
    set(handles.v2start,'Enable','Off');
    set(handles.v2stop,'Enable','Off');
    set(handles.v2step,'Enable','Off');
    set(handles.i2comp,'Enable','Off');
    set(handles.p2comp,'Enable','Off');        
end
% check if no bias
if ~handles.instr.measure_dc1 && ~handles.instr.measure_dc2 && ~handles.SETUP.DEMO
    set(handles.addbias,'Enable','Off');
    set(handles.clearbias,'Enable','Off');
end
close(h_wb);

% initiate save path
handles.SavePath = 'data/*.mat';

% Smithchart initialization
init_smith(handles.smith);

% plot GL grid
grid = str2double(get(handles.gammagrid,'String'));
plotGL(grid,handles.smith); % get the possible impedances

% initiate number of meas points
handles.numGL = 0;
handles.numGL2 = 0;
handles.numBIAS = 0;

% set number of bias regions to 0
handles.num_regions = 0;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes MeasLSNA wait for user response (see UIRESUME)
uiwait(handles.figure);


function varargout = MeasLSNA_OutputFcn(hObject, eventdata, handles)
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
% update bias counter
set(handles.cbias,'String',num2str(handles.numBIAS));
% Update handles structure
guidata(hObject, handles);


function clearbias_Callback(hObject, eventdata, handles)
handles = ClearBias(handles); % clear bias
% update bias counter
set(handles.cbias,'String',num2str(handles.numBIAS));
guidata(hObject, handles); % Update handles structure

function i1comp_Callback(hObject, eventdata, handles)
function i1comp_CreateFcn(hObject, eventdata, handles)
function i2comp_Callback(hObject, eventdata, handles)
function i2comp_CreateFcn(hObject, eventdata, handles)
function p1comp_Callback(hObject, eventdata, handles)
function p1comp_CreateFcn(hObject, eventdata, handles)
function p2comp_Callback(hObject, eventdata, handles)
function p2comp_CreateFcn(hObject, eventdata, handles)

function measure_Callback(hObject, eventdata, handles)
MEASTYPE = handles.SETUP.MEASTYPE; % resave meastype

% check if GL needs to be selected
SELGL = strcmp(MEASTYPE,'ACTIVELP') || strcmp(MEASTYPE,'ACTIVELP_ATT');

% check if GL2 needs to be selected
SELGL2 = (handles.SETUP.NUMMOD > 1);

% check if BIAS needs to be selected
SELBIAS = handles.instr.measure_dc1 || handles.instr.measure_dc2;

% check if OK for measurement
if handles.SETUP.DEMO
    % Demo measurement
    OutData.SETUP = handles.SETUP;
    % Measure
    ResultLSNAOut = ResultLSNA(handles,OutData);
    handles.SavePath = ResultLSNAOut;
    % Update handles structure
    guidata(hObject, handles);    
elseif SELGL && (handles.numGL == 0)
    msgbox('No Fundamental Gamma is selected. Please select at least one Fundamental Gamma!','Error','error');
elseif SELGL2 && (handles.numGL2 == 0)
    msgbox('No 2nd Harmonic Gamma is selected. Please select one 2nd Harmonic Gamma!','Error','error');
elseif SELBIAS && (handles.numBIAS == 0)
    msgbox('No Bias Point is given. Please select at least one Bias Point!','Error','error');
else
    % Instruments
    OutData.instr = handles.instr; 
    % Get the bias grid
    OutData.BIAS = GetBIAS(handles);
    
    % check if load pull
    if strcmp(MEASTYPE,'ACTIVELP') || strcmp(MEASTYPE,'ACTIVELP_ATT')
        % Gamma
        OutData.GL(1,:) = handles.GL;
        if handles.SETUP.NUMMOD == 2
            OutData.GL(2,:) = handles.GL2.*ones(1,length(handles.GL));
        end
    end

    % Input power
    pstart = str2double(get(handles.Pstart,'String'));
    pstop = str2double(get(handles.Pstop,'String'));
    pstep = str2double(get(handles.Pstep,'String'));
    if (pstart == pstop) || (pstep == 0) % check if single point
        OutData.PIN = pstart;
    else
        OutData.PIN = pstart:pstep:pstop;
    end
    
    % setup
    OutData.SETUP = handles.SETUP;
    
    % Measure
    ResultLSNAOut = ResultLSNA(handles,OutData);
    try
        handles.SavePath = ResultLSNAOut{1}
    catch
    end
    
    % Update handles structure
    guidata(hObject, handles);
end

function figure_CreateFcn(hObject, eventdata, handles)

function selfund_Callback(hObject, eventdata, handles)
% select fundamental load reflections
set(hObject,'Value',1);
set(handles.selharm,'Value',0);

% Enable controls
set(handles.MinMag,'Enable','On');
set(handles.MaxMag,'Enable','On');
set(handles.MinAng,'Enable','On');
set(handles.MaxAng,'Enable','On');
set(handles.AddRegion,'Enable','On');


function selharm_Callback(hObject, eventdata, handles)
% select harmonic load reflections
set(hObject,'Value',1);
set(handles.selfund,'Value',0);

% Disable controls
set(handles.MinMag,'Enable','Off');
set(handles.MaxMag,'Enable','Off');
set(handles.MinAng,'Enable','Off');
set(handles.MaxAng,'Enable','Off');
set(handles.AddRegion,'Enable','Off');


function gammagrid_Callback(hObject, eventdata, handles)
function gammagrid_CreateFcn(hObject, eventdata, handles)

function setgrid_Callback(hObject, eventdata, handles)
% set grid spacing in smithchart
grid = str2double(get(handles.gammagrid,'String'));

% clear all selected GL
handles.numGL = 0;
clear handles.GL;
clear handles.GL2;
set(handles.loadgrid,'String','');

% clear smithchart
axes(handles.smith);
h = get(gca,'Children');
set(h(1),'Xdata',[],'Ydata',[]);
set(h(2),'Xdata',[],'Ydata',[]);
set(h(3),'Xdata',[],'Ydata',[]);
plotGL(grid,handles.smith);

% update gl counter
set(handles.cgl,'String',num2str(handles.numGL));


function smith_CreateFcn(hObject, eventdata, handles)
function smith_ButtonDownFcn(hObject, eventdata, handles)
function loadgrid_Callback(hObject, eventdata, handles)
function loadgrid_CreateFcn(hObject, eventdata, handles)

function powercal_Callback(hObject, eventdata, handles)
PwrCal = PowerCal(handles.instr,handles.SETUP);

% update SETUP
handles.SETUP = PwrCal;
set(handles.measure,'Enable','On');
guidata(hObject, handles);


function MinMag_Callback(hObject, eventdata, handles)
function MinMag_CreateFcn(hObject, eventdata, handles)
function MaxMag_Callback(hObject, eventdata, handles)
function MaxMag_CreateFcn(hObject, eventdata, handles)
function MinAng_Callback(hObject, eventdata, handles)
function MinAng_CreateFcn(hObject, eventdata, handles)

function AddRegion_Callback(hObject, eventdata, handles)
% get GL region limits
MinAng = str2double(get(handles.MinAng,'String'));
MaxAng = str2double(get(handles.MaxAng,'String'));
MinMag = str2double(get(handles.MinMag,'String'));
MaxMag = str2double(get(handles.MaxMag,'String'));

% convert degrees to radians
MinAng = MinAng*pi/180;
MaxAng = MaxAng*pi/180;

% get grid data
h = get(handles.smith, 'Children');
xdata = get(h(1),'XData');
ydata = get(h(1),'YData');
selected_index = get(h(2),'UserData');
GL = xdata + j*ydata; % possible gammas

% get selected grid points
if MaxAng <= pi 
    ix=find(abs(GL) <= MaxMag & abs(GL) >= MinMag & angle(GL) <= MaxAng & angle(GL) >= MinAng);
else % check if 180 degree passing
    tmp = MaxAng - 2*pi;
    ix1 = find(abs(GL) <= MaxMag & abs(GL) >= MinMag & angle(GL) <= pi & angle(GL) >= MinAng);
    ix2 = find(abs(GL) <= MaxMag & abs(GL) >= MinMag & angle(GL) <= tmp & angle(GL) >= -pi);
    ix = [ix1 ix2];
end

% update smithplot
for Idx = 1:length(ix)
    if ~sum((selected_index == ix(Idx))) % check if selected
        temp = get(h(2), 'UserData');
        set(h(2),'UserData',[temp ix(Idx)]);
        temp = get(h(2), 'XData');
        set(h(2),'XData',[temp xdata(ix(Idx))]);
        temp = get(h(2), 'YData');
        set(h(2),'YData',[temp ydata(ix(Idx))]);
    end
end

% read out all selected gammas
GLx = get(h(2), 'XData').';
GLy = get(h(2), 'YData').';
handles.GL = GLx + j*GLy;
handles.numGL = length(handles.GL);

% Update Load reflection list
strGL = num2str(round(100.*handles.GL)./100);
set(handles.loadgrid,'String',strGL);
% update gl counter
set(handles.cgl,'String',num2str(handles.numGL));


function MaxAng_Callback(hObject, eventdata, handles)
function MaxAng_CreateFcn(hObject, eventdata, handles)

function cleargamma_Callback(hObject, eventdata, handles)
% clear all selected GL
handles.numGL = 0;
clear handles.GL;
clear handles.GL2;
set(handles.loadgrid,'String','');

% clear smithchart
grid = str2double(get(handles.gammagrid,'String'));
axes(handles.smith);
h = get(gca,'Children');
set(h(1),'Xdata',[],'Ydata',[]);
set(h(2),'Xdata',[],'Ydata',[]);
set(h(3),'Xdata',[],'Ydata',[]);
plotGL(grid,handles.smith);

% update gl counter
set(handles.cgl,'String',num2str(handles.numGL));


function AddPoint_Callback(hObject, eventdata, handles)
function gammapoint_Callback(hObject, eventdata, handles)
function gammapoint_CreateFcn(hObject, eventdata, handles)
function Pstart_Callback(hObject, eventdata, handles)
function Pstart_CreateFcn(hObject, eventdata, handles)
function Pstop_Callback(hObject, eventdata, handles)
function Pstop_CreateFcn(hObject, eventdata, handles)
function Pstep_Callback(hObject, eventdata, handles)
function Pstep_CreateFcn(hObject, eventdata, handles)

function close_Callback(hObject, eventdata, handles)
% Excecuted when MeasLSNA exits
if handles.SETUP.DEMO == 0
    instrreset;
    if handles.SETUP.NUMATT > 0
        delete(handles.instr.ao);
    end
    % close lsna
    hlsna = calllib('lsnaapi','LSNAclose');
    unloadlibrary('lsnaapi');
%     if handles.SETUP.NUMMOD > 0
%         delete(handles.instr.dio);
%     end
end

uiresume(handles.figure);

function reset_Callback(hObject, eventdata, handles)
% reset instruments
reset_instr(handles.instr);
disp('Input power and bias are turned off');

function savesetup_Callback(hObject, eventdata, handles)
% save bias, power and load reflection settings
SaveSetup(handles,'LSNA');

function loadsetup_Callback(hObject, eventdata, handles)
% load bias, power and load reflection settings
handles = LoadSetup(handles,'LSNA');
% Update handles structure
guidata(hObject, handles);

function figure_CloseRequestFcn(hObject, eventdata, handles)
uiresume(handles.figure);


% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure_WindowButtonDownFcn(hObject, eventdata, handles)
switch handles.SETUP.MEASTYPE
    case {'ACTIVELP','ACTIVELP_ATT','DEMO'}
        position = get(handles.smith,'CurrentPoint');

        x = position(1,1);
        y = position(1,2);

        SelMag = sqrt(x.^2+y.^2); % magnitude of selected point

        % check if within smithchart
        if SelMag < 1.05
            h = get(handles.smith, 'Children');
            xdata = get(h(1),'XData');
            ydata = get(h(1),'YData');

            % Get index to closest data point
            delta = (xdata - x).^2 + (ydata - y).^2;
            [void, index] = min(delta);

            % check if fundamental or harmonic
            FUND = get(handles.selfund,'Value');
            if FUND
                selected_index = get(h(2),'UserData');
                toggle = find(index == selected_index);
                if isempty(toggle)
                    temp = get(h(2), 'UserData');
                    set(h(2),'UserData',[temp index]);
                    temp = get(h(2), 'XData');
                    set(h(2),'XData',[temp xdata(index)]);
                    temp = get(h(2), 'YData');
                    set(h(2),'YData',[temp ydata(index)]);
                else
                    selected_index(toggle) = [];
                    set(h(2),'UserData',selected_index);
                    set(h(2),'XData',xdata(selected_index));
                    set(h(2),'YData',ydata(selected_index));
                end

                GLx = get(h(2), 'XData').';
                GLy = get(h(2), 'YData').';
                handles.GL = GLx + j*GLy;
                handles.numGL = length(handles.GL);

                % Update Load reflection list
                set(handles.loadgrid,'Value',1);
                strGL = num2str(round(100.*handles.GL)./100);
                set(handles.loadgrid,'String',strGL);

            else % harmonic reflection
                selected_index = get(h(3),'UserData');
                if index == selected_index;
                    set(h(3),'UserData',[]);
                    set(h(3),'XData',[]);
                    set(h(3),'YData',[]);
                    handles.GL2 = [];
                    handles.numGL2 = 0;
                else
                    set(h(3),'UserData',index);
                    set(h(3),'XData',xdata(index));
                    set(h(3),'YData',ydata(index));
                    handles.GL2 = xdata(index) + j*ydata(index);
                    handles.numGL2 = 1;
                end
            end

            % update gl counter
            set(handles.cgl,'String',num2str(handles.numGL));
            % update handles
            guidata(hObject, handles);
        end
end

