function varargout = PowerCal(varargin)
% POWERCAL M-file for PowerCal.fig
%      POWERCAL, by itself, creates a new POWERCAL or raises the existing
%      singleton*.
%
%      H = POWERCAL returns the handle to a new POWERCAL or the handle to
%      the existing singleton*.
%
%      POWERCAL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in POWERCAL.M with the given input arguments.
%
%      POWERCAL('Property','Value',...) creates a new POWERCAL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before PowerCal_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to PowerCal_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help PowerCal

% Last Modified by GUIDE v2.5 11-Aug-2009 16:56:24

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @PowerCal_OpeningFcn, ...
                   'gui_OutputFcn',  @PowerCal_OutputFcn, ...
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


% --- Executes just before PowerCal is made visible.
function PowerCal_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to PowerCal (see VARARGIN)

% Choose default command line output for PowerCal
handles.output = hObject;

% get instrument information
handles.instr = varargin{1};
% get settings
handles.SETUP = varargin{2};

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes PowerCal wait for user response (see UIRESUME)
uiwait(handles.figure);


% --- Outputs from this function are returned to the command line.
function varargout = PowerCal_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.SETUP;
delete(hObject);


function MaxPwr_Callback(hObject, eventdata, handles)
% hObject    handle to MaxPwr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of MaxPwr as text
%        str2double(get(hObject,'String')) returns contents of MaxPwr as a double


% --- Executes during object creation, after setting all properties.
function MaxPwr_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MaxPwr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function VCstart_Callback(hObject, eventdata, handles)
% hObject    handle to VCstart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of VCstart as text
%        str2double(get(hObject,'String')) returns contents of VCstart as a double


% --- Executes during object creation, after setting all properties.
function VCstart_CreateFcn(hObject, eventdata, handles)
% hObject    handle to VCstart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function VCstep_Callback(hObject, eventdata, handles)
% hObject    handle to VCstep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of VCstep as text
%        str2double(get(hObject,'String')) returns contents of VCstep as a double


% --- Executes during object creation, after setting all properties.
function VCstep_CreateFcn(hObject, eventdata, handles)
% hObject    handle to VCstep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function VCstop_Callback(hObject, eventdata, handles)
% hObject    handle to VCstop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of VCstop as text
%        str2double(get(hObject,'String')) returns contents of VCstop as a double


% --- Executes during object creation, after setting all properties.
function VCstop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to VCstop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function AttSettle_Callback(hObject, eventdata, handles)
% hObject    handle to AttSettle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of AttSettle as text
%        str2double(get(hObject,'String')) returns contents of AttSettle as a double


% --- Executes during object creation, after setting all properties.
function AttSettle_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AttSettle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in measure.
function measure_Callback(hObject, eventdata, handles)
% hObject    handle to measure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% setup calibration measurement
SETUP = handles.SETUP;
CAL.MAXPWR = str2double(get(handles.MaxPwr,'String'));
CAL.ATTSETTLE = str2double(get(handles.AttSettle,'String'));
vcstart = str2double(get(handles.VCstart,'String'));
vcstep = str2double(get(handles.VCstep,'String'));
vcstop = str2double(get(handles.VCstop,'String'));
CAL.VC = vcstart:vcstep:vcstop;

% perfrom calibration measurement
caldata = PowerCalMeas(SETUP, CAL, handles.instr);

% calculate fitting parameters
SETUP.PinFit = polyfit(caldata.Pin,caldata.VC,2);
CAL.Y = GetVC(caldata.Pin,SETUP.PinFit);

% plot the fitting
axes(handles.ax1);
plot(caldata.Pin,caldata.VC,caldata.Pin,CAL.Y,'o');

% update output
handles.SETUP = SETUP;

% enable done button
set(handles.done,'Enable','On');

guidata(hObject, handles);

% --- Executes on button press in cancel.
function cancel_Callback(hObject, eventdata, handles)
% hObject    handle to cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uiresume(handles.figure);


% --- Executes on button press in done.
function done_Callback(hObject, eventdata, handles)
% hObject    handle to done (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uiresume(handles.figure);


% --- Executes when user attempts to close figure.
function figure_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
uiresume(handles.figure);


