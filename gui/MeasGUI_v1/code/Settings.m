function varargout = Settings(varargin)
% SETTINGS M-file for Settings.fig
%      SETTINGS, by itself, creates a new SETTINGS or raises the existing
%      singleton*.
%
%      H = SETTINGS returns the handle to a new SETTINGS or the handle to
%      the existing singleton*.
%
%      SETTINGS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SETTINGS.M with the given input arguments.
%
%      SETTINGS('Property','Value',...) creates a new SETTINGS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Settings_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Settings_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Settings

% Last Modified by GUIDE v2.5 11-Aug-2009 16:56:04

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Settings_OpeningFcn, ...
                   'gui_OutputFcn',  @Settings_OutputFcn, ...
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


% --- Executes just before Settings is made visible.
function Settings_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Settings (see VARARGIN)

handles.SETUP = varargin{1};

% Choose default command line output for Settings
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

tmp = handles.SETUP;

set(handles.sourcefrq,'String',num2str(tmp.FRQ/1e9)); % set frequency
set(handles.sourcepwr,'String',num2str(tmp.PWR)); % set power
set(handles.sourcesafepwr,'String',num2str(tmp.SAFEPWR)); % set safe power

set(handles.attvcstep,'String',num2str(tmp.VCSTEP)); % attenuator step length

set(handles.biastime,'String',num2str(tmp.BIAS_SETTLE)); % bias settling time

set(handles.optstep,'String',num2str(tmp.OPTIMSTEP)); % set optimization step

% set number of modulators
str = str2num(char(get(handles.nummodulators,'String')));
set(handles.nummodulators,'Value',find(str==tmp.NUMMOD));
switch tmp.NUMMOD
    case 0
        set(handles.mod1tone,'Enable','off');
        set(handles.mod2tone,'Enable','off');
        set(handles.mod3tone,'Enable','off');
        set(handles.mod4tone,'Enable','off');
        set(handles.mod1i,'Enable','off');
        set(handles.mod2i,'Enable','off');
        set(handles.mod3i,'Enable','off');
        set(handles.mod4i,'Enable','off');
        set(handles.mod1q,'Enable','off');
        set(handles.mod2q,'Enable','off');
        set(handles.mod3q,'Enable','off');
        set(handles.mod4q,'Enable','off');        
    case 1
        set(handles.mod1tone,'Enable','on');
        set(handles.mod2tone,'Enable','off');
        set(handles.mod3tone,'Enable','off');
        set(handles.mod4tone,'Enable','off');
        set(handles.mod1i,'Enable','on');
        set(handles.mod2i,'Enable','off');
        set(handles.mod3i,'Enable','off');
        set(handles.mod4i,'Enable','off');
        set(handles.mod1q,'Enable','on');
        set(handles.mod2q,'Enable','off');
        set(handles.mod3q,'Enable','off');
        set(handles.mod4q,'Enable','off');        
    case 2
        set(handles.mod1tone,'Enable','on');
        set(handles.mod2tone,'Enable','on');
        set(handles.mod3tone,'Enable','off');
        set(handles.mod4tone,'Enable','off');
        set(handles.mod1i,'Enable','on');
        set(handles.mod2i,'Enable','on');
        set(handles.mod3i,'Enable','off');
        set(handles.mod4i,'Enable','off');
        set(handles.mod1q,'Enable','on');
        set(handles.mod2q,'Enable','on');
        set(handles.mod3q,'Enable','off');
        set(handles.mod4q,'Enable','off');         
    case 3
        set(handles.mod1tone,'Enable','on');
        set(handles.mod2tone,'Enable','on');
        set(handles.mod3tone,'Enable','on');
        set(handles.mod4tone,'Enable','off');
        set(handles.mod1i,'Enable','on');
        set(handles.mod2i,'Enable','on');
        set(handles.mod3i,'Enable','on');
        set(handles.mod4i,'Enable','off');
        set(handles.mod1q,'Enable','on');
        set(handles.mod2q,'Enable','on');
        set(handles.mod3q,'Enable','on');
        set(handles.mod4q,'Enable','off');         
    case 4
        set(handles.mod1tone,'Enable','on');
        set(handles.mod2tone,'Enable','on');
        set(handles.mod3tone,'Enable','on');
        set(handles.mod4tone,'Enable','on');
        set(handles.mod1i,'Enable','on');
        set(handles.mod2i,'Enable','on');
        set(handles.mod3i,'Enable','on');
        set(handles.mod4i,'Enable','on');
        set(handles.mod1q,'Enable','on');
        set(handles.mod2q,'Enable','on');
        set(handles.mod3q,'Enable','on');
        set(handles.mod4q,'Enable','on');         
end

% set modulator1 info
str = str2num(char(get(handles.mod1tone,'String')));
set(handles.mod1tone,'Value',find(str==tmp.TONE(1)));
set(handles.mod1i,'String',num2str(tmp.SV(1,1)));
set(handles.mod1q,'String',num2str(tmp.SV(1,2)));

% set modulator2 info
str = str2num(char(get(handles.mod2tone,'String')));
set(handles.mod2tone,'Value',find(str==tmp.TONE(2)));
set(handles.mod2i,'String',num2str(tmp.SV(2,1)));
set(handles.mod2q,'String',num2str(tmp.SV(2,2)));

% set modulator3 info
str = str2num(char(get(handles.mod3tone,'String')));
set(handles.mod3tone,'Value',find(str==tmp.TONE(3)));
set(handles.mod3i,'String',num2str(tmp.SV(3,1)));
set(handles.mod3q,'String',num2str(tmp.SV(3,2)));

% set modulator4 info
str = str2num(char(get(handles.mod4tone,'String')));
set(handles.mod4tone,'Value',find(str==tmp.TONE(4)));
set(handles.mod4i,'String',num2str(tmp.SV(4,1)));
set(handles.mod4q,'String',num2str(tmp.SV(4,2)));

% set number of attenuators
str = str2num(char(get(handles.numattenuators,'String')));
set(handles.numattenuators,'Value',find(str==tmp.NUMATT));

switch tmp.NUMATT
    case 0
        set(handles.att1sv,'Enable','off');
        set(handles.att2sv,'Enable','off');
        set(handles.att3sv,'Enable','off');
        set(handles.att4sv,'Enable','off');       
    case 1
        set(handles.att1sv,'Enable','on');
        set(handles.att2sv,'Enable','off');
        set(handles.att3sv,'Enable','off');
        set(handles.att4sv,'Enable','off');       
    case 2
        set(handles.att1sv,'Enable','on');
        set(handles.att2sv,'Enable','on');
        set(handles.att3sv,'Enable','off');
        set(handles.att4sv,'Enable','off');        
    case 3
        set(handles.att1sv,'Enable','on');
        set(handles.att2sv,'Enable','on');
        set(handles.att3sv,'Enable','on');
        set(handles.att4sv,'Enable','off'); 
    case 4
        set(handles.att1sv,'Enable','on');
        set(handles.att2sv,'Enable','on');
        set(handles.att3sv,'Enable','on');
        set(handles.att4sv,'Enable','on');        
end

set(handles.att1sv,'String',num2str(tmp.VCSTART(1))); % attenuator 1 start value
set(handles.att2sv,'String',num2str(tmp.VCSTART(2))); % attenuator 2 start value
set(handles.att3sv,'String',num2str(tmp.VCSTART(3))); % attenuator 3 start value
set(handles.att4sv,'String',num2str(tmp.VCSTART(4))); % attenuator 4 start value

% UIWAIT makes Settings wait for user response (see UIRESUME)
uiwait(handles.figure);


% --- Outputs from this function are returned to the command line.
function varargout = Settings_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.SETUP;
delete(hObject);



function sourcefrq_Callback(hObject, eventdata, handles)
% hObject    handle to sourcefrq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sourcefrq as text
%        str2double(get(hObject,'String')) returns contents of sourcefrq as a double


% --- Executes during object creation, after setting all properties.
function sourcefrq_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sourcefrq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function sourcepwr_Callback(hObject, eventdata, handles)
% hObject    handle to sourcepwr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sourcepwr as text
%        str2double(get(hObject,'String')) returns contents of sourcepwr as a double


% --- Executes during object creation, after setting all properties.
function sourcepwr_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sourcepwr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function sourcesafepwr_Callback(hObject, eventdata, handles)
% hObject    handle to sourcesafepwr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sourcesafepwr as text
%        str2double(get(hObject,'String')) returns contents of sourcesafepwr as a double


% --- Executes during object creation, after setting all properties.
function sourcesafepwr_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sourcesafepwr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to sourcefrq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sourcefrq as text
%        str2double(get(hObject,'String')) returns contents of sourcefrq as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sourcefrq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to sourcepwr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sourcepwr as text
%        str2double(get(hObject,'String')) returns contents of sourcepwr as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sourcepwr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to sourcesafepwr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sourcesafepwr as text
%        str2double(get(hObject,'String')) returns contents of sourcesafepwr as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sourcesafepwr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in nummodulators.
function nummodulators_Callback(hObject, eventdata, handles)
% hObject    handle to nummodulators (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns nummodulators contents as cell array
%         returns selected item from nummodulators
contents = get(hObject,'String');
Mod = str2num(contents{get(hObject,'Value')});
switch Mod
    case 0
        set(handles.mod1tone,'Enable','off');
        set(handles.mod2tone,'Enable','off');
        set(handles.mod3tone,'Enable','off');
        set(handles.mod4tone,'Enable','off');
        set(handles.mod1i,'Enable','off');
        set(handles.mod2i,'Enable','off');
        set(handles.mod3i,'Enable','off');
        set(handles.mod4i,'Enable','off');
        set(handles.mod1q,'Enable','off');
        set(handles.mod2q,'Enable','off');
        set(handles.mod3q,'Enable','off');
        set(handles.mod4q,'Enable','off');        
    case 1
        set(handles.mod1tone,'Enable','on');
        set(handles.mod2tone,'Enable','off');
        set(handles.mod3tone,'Enable','off');
        set(handles.mod4tone,'Enable','off');
        set(handles.mod1i,'Enable','on');
        set(handles.mod2i,'Enable','off');
        set(handles.mod3i,'Enable','off');
        set(handles.mod4i,'Enable','off');
        set(handles.mod1q,'Enable','on');
        set(handles.mod2q,'Enable','off');
        set(handles.mod3q,'Enable','off');
        set(handles.mod4q,'Enable','off');        
    case 2
        set(handles.mod1tone,'Enable','on');
        set(handles.mod2tone,'Enable','on');
        set(handles.mod3tone,'Enable','off');
        set(handles.mod4tone,'Enable','off');
        set(handles.mod1i,'Enable','on');
        set(handles.mod2i,'Enable','on');
        set(handles.mod3i,'Enable','off');
        set(handles.mod4i,'Enable','off');
        set(handles.mod1q,'Enable','on');
        set(handles.mod2q,'Enable','on');
        set(handles.mod3q,'Enable','off');
        set(handles.mod4q,'Enable','off');         
    case 3
        set(handles.mod1tone,'Enable','on');
        set(handles.mod2tone,'Enable','on');
        set(handles.mod3tone,'Enable','on');
        set(handles.mod4tone,'Enable','off');
        set(handles.mod1i,'Enable','on');
        set(handles.mod2i,'Enable','on');
        set(handles.mod3i,'Enable','on');
        set(handles.mod4i,'Enable','off');
        set(handles.mod1q,'Enable','on');
        set(handles.mod2q,'Enable','on');
        set(handles.mod3q,'Enable','on');
        set(handles.mod4q,'Enable','off');         
    case 4
        set(handles.mod1tone,'Enable','on');
        set(handles.mod2tone,'Enable','on');
        set(handles.mod3tone,'Enable','on');
        set(handles.mod4tone,'Enable','on');
        set(handles.mod1i,'Enable','on');
        set(handles.mod2i,'Enable','on');
        set(handles.mod3i,'Enable','on');
        set(handles.mod4i,'Enable','on');
        set(handles.mod1q,'Enable','on');
        set(handles.mod2q,'Enable','on');
        set(handles.mod3q,'Enable','on');
        set(handles.mod4q,'Enable','on');         
end
        
% --- Executes during object creation, after setting all properties.
function nummodulators_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nummodulators (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in mod1tone.
function mod1tone_Callback(hObject, eventdata, handles)
% hObject    handle to mod1tone (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns mod1tone contents as cell array
%        contents{get(hObject,'Value')} returns selected item from mod1tone


% --- Executes during object creation, after setting all properties.
function mod1tone_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mod1tone (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in mod2tone.
function mod2tone_Callback(hObject, eventdata, handles)
% hObject    handle to mod2tone (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns mod2tone contents as cell array
%        contents{get(hObject,'Value')} returns selected item from mod2tone


% --- Executes during object creation, after setting all properties.
function mod2tone_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mod2tone (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in mod3tone.
function mod3tone_Callback(hObject, eventdata, handles)
% hObject    handle to mod3tone (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns mod3tone contents as cell array
%        contents{get(hObject,'Value')} returns selected item from mod3tone


% --- Executes during object creation, after setting all properties.
function mod3tone_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mod3tone (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in mod4tone.
function mod4tone_Callback(hObject, eventdata, handles)
% hObject    handle to mod4tone (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns mod4tone contents as cell array
%        contents{get(hObject,'Value')} returns selected item from mod4tone


% --- Executes during object creation, after setting all properties.
function mod4tone_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mod4tone (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function mod1i_Callback(hObject, eventdata, handles)
% hObject    handle to mod1i (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mod1i as text
%        str2double(get(hObject,'String')) returns contents of mod1i as a double


% --- Executes during object creation, after setting all properties.
function mod1i_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mod1i (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function mod2i_Callback(hObject, eventdata, handles)
% hObject    handle to mod2i (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mod2i as text
%        str2double(get(hObject,'String')) returns contents of mod2i as a double


% --- Executes during object creation, after setting all properties.
function mod2i_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mod2i (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function mod3i_Callback(hObject, eventdata, handles)
% hObject    handle to mod3i (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mod3i as text
%        str2double(get(hObject,'String')) returns contents of mod3i as a double


% --- Executes during object creation, after setting all properties.
function mod3i_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mod3i (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function mod4i_Callback(hObject, eventdata, handles)
% hObject    handle to mod4i (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mod4i as text
%        str2double(get(hObject,'String')) returns contents of mod4i as a double


% --- Executes during object creation, after setting all properties.
function mod4i_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mod4i (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function mod1q_Callback(hObject, eventdata, handles)
% hObject    handle to mod1q (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mod1q as text
%        str2double(get(hObject,'String')) returns contents of mod1q as a double


% --- Executes during object creation, after setting all properties.
function mod1q_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mod1q (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function mod2q_Callback(hObject, eventdata, handles)
% hObject    handle to mod2q (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mod2q as text
%        str2double(get(hObject,'String')) returns contents of mod2q as a double


% --- Executes during object creation, after setting all properties.
function mod2q_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mod2q (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function mod3q_Callback(hObject, eventdata, handles)
% hObject    handle to mod3q (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mod3q as text
%        str2double(get(hObject,'String')) returns contents of mod3q as a double


% --- Executes during object creation, after setting all properties.
function mod3q_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mod3q (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function mod4q_Callback(hObject, eventdata, handles)
% hObject    handle to mod4q (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mod4q as text
%        str2double(get(hObject,'String')) returns contents of mod4q as a double


% --- Executes during object creation, after setting all properties.
function mod4q_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mod4q (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function optstep_Callback(hObject, eventdata, handles)
% hObject    handle to optstep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of optstep as text
%        str2double(get(hObject,'String')) returns contents of optstep as a double


% --- Executes during object creation, after setting all properties.
function optstep_CreateFcn(hObject, eventdata, handles)
% hObject    handle to optstep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit19_Callback(hObject, eventdata, handles)
% hObject    handle to edit19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit19 as text
%        str2double(get(hObject,'String')) returns contents of edit19 as a double


% --- Executes during object creation, after setting all properties.
function edit19_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit20_Callback(hObject, eventdata, handles)
% hObject    handle to edit20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit20 as text
%        str2double(get(hObject,'String')) returns contents of edit20 as a double


% --- Executes during object creation, after setting all properties.
function edit20_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit21_Callback(hObject, eventdata, handles)
% hObject    handle to edit21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit21 as text
%        str2double(get(hObject,'String')) returns contents of edit21 as a double


% --- Executes during object creation, after setting all properties.
function edit21_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in numattenuators.
function numattenuators_Callback(hObject, eventdata, handles)
% hObject    handle to numattenuators (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns numattenuators contents as cell array
%        contents{get(hObject,'Value')} returns selected item from numattenuators
contents = get(hObject,'String');
Att = str2num(contents{get(hObject,'Value')});
switch Att
    case 0
        set(handles.att1sv,'Enable','off');
        set(handles.att2sv,'Enable','off');
        set(handles.att3sv,'Enable','off');
        set(handles.att4sv,'Enable','off');       
    case 1
        set(handles.att1sv,'Enable','on');
        set(handles.att2sv,'Enable','off');
        set(handles.att3sv,'Enable','off');
        set(handles.att4sv,'Enable','off');       
    case 2
        set(handles.att1sv,'Enable','on');
        set(handles.att2sv,'Enable','on');
        set(handles.att3sv,'Enable','off');
        set(handles.att4sv,'Enable','off');        
    case 3
        set(handles.att1sv,'Enable','on');
        set(handles.att2sv,'Enable','on');
        set(handles.att3sv,'Enable','on');
        set(handles.att4sv,'Enable','off'); 
    case 4
        set(handles.att1sv,'Enable','on');
        set(handles.att2sv,'Enable','on');
        set(handles.att3sv,'Enable','on');
        set(handles.att4sv,'Enable','on');        
end

% --- Executes during object creation, after setting all properties.
function numattenuators_CreateFcn(hObject, eventdata, handles)
% hObject    handle to numattenuators (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function att1sv_Callback(hObject, eventdata, handles)
% hObject    handle to att1sv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of att1sv as text
%        str2double(get(hObject,'String')) returns contents of att1sv as a double


% --- Executes during object creation, after setting all properties.
function att1sv_CreateFcn(hObject, eventdata, handles)
% hObject    handle to att1sv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function att2sv_Callback(hObject, eventdata, handles)
% hObject    handle to att2sv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of att2sv as text
%        str2double(get(hObject,'String')) returns contents of att2sv as a double


% --- Executes during object creation, after setting all properties.
function att2sv_CreateFcn(hObject, eventdata, handles)
% hObject    handle to att2sv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function att3sv_Callback(hObject, eventdata, handles)
% hObject    handle to att3sv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of att3sv as text
%        str2double(get(hObject,'String')) returns contents of att3sv as a double


% --- Executes during object creation, after setting all properties.
function att3sv_CreateFcn(hObject, eventdata, handles)
% hObject    handle to att3sv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function att4sv_Callback(hObject, eventdata, handles)
% hObject    handle to att4sv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of att4sv as text
%        str2double(get(hObject,'String')) returns contents of att4sv as a double


% --- Executes during object creation, after setting all properties.
function att4sv_CreateFcn(hObject, eventdata, handles)
% hObject    handle to att4sv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function attvcstep_Callback(hObject, eventdata, handles)
% hObject    handle to attvcstep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of attvcstep as text
%        str2double(get(hObject,'String')) returns contents of attvcstep as a double


% --- Executes during object creation, after setting all properties.
function attvcstep_CreateFcn(hObject, eventdata, handles)
% hObject    handle to attvcstep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in save.
function save_Callback(hObject, eventdata, handles)
% hObject    handle to save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in load.
function load_Callback(hObject, eventdata, handles)
% hObject    handle to load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in cancel.
function cancel_Callback(hObject, eventdata, handles)
% hObject    handle to cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uiresume(handles.figure);

% --- Executes on button press in ok.
function ok_Callback(hObject, eventdata, handles)
% hObject    handle to ok (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ok
tmp = handles.SETUP;

tmp.FRQ = str2double(get(handles.sourcefrq,'String')).*1e9; % get frequency
tmp.PWR = str2double(get(handles.sourcepwr,'String')); % get power
tmp.SAFEPWR = str2double(get(handles.sourcesafepwr,'String')); % get safe power
tmp.OPTIMSTEP = str2double(get(handles.optstep,'String')); % get optimization step

% get number of modulators
nummod = get(handles.nummodulators,'String');
tmp.NUMMOD = str2double(nummod{get(handles.nummodulators,'Value')});

% get modulator1 info
mod1tone = get(handles.mod1tone,'String');
tmp.TONE(1) = str2double(mod1tone{get(handles.mod1tone,'Value')});
tmp.SV(1,1) = str2double(get(handles.mod1i,'String'));
tmp.SV(1,2) = str2double(get(handles.mod1q,'String'));

% get modulator2 info
mod2tone = get(handles.mod2tone,'String');
tmp.TONE(2) = str2double(mod2tone{get(handles.mod2tone,'Value')});
tmp.SV(2,1) = str2double(get(handles.mod2i,'String'));
tmp.SV(2,2) = str2double(get(handles.mod2q,'String'));

% get modulator3 info
mod3tone = get(handles.mod3tone,'String');
tmp.TONE(3) = str2double(mod3tone{get(handles.mod3tone,'Value')});
tmp.SV(3,1) = str2double(get(handles.mod3i,'String'));
tmp.SV(3,2) = str2double(get(handles.mod3q,'String'));

% get modulator4 info
mod4tone = get(handles.mod4tone,'String');
tmp.TONE(4) = str2double(mod4tone{get(handles.mod4tone,'Value')});
tmp.SV(4,1) = str2double(get(handles.mod4i,'String'));
tmp.SV(4,2) = str2double(get(handles.mod4q,'String'));

% get number of attenuators
nummod = get(handles.numattenuators,'String');
tmp.NUMATT = str2double(nummod{get(handles.numattenuators,'Value')});

tmp.VCSTART(1) = str2double(get(handles.att1sv,'String')); % attenuator 1 start value
tmp.VCSTART(2) = str2double(get(handles.att2sv,'String')); % attenuator 2 start value
tmp.VCSTART(3) = str2double(get(handles.att3sv,'String')); % attenuator 3 start value
tmp.VCSTART(4) = str2double(get(handles.att4sv,'String')); % attenuator 4 start value

tmp.VCSTEP = str2double(get(handles.attvcstep,'String')); % attenuator step length

tmp.BIAS_SETTLE = str2double(get(handles.biastime,'String')); % bias settle time

handles.SETUP = tmp;
guidata(hObject,handles); % save updated SETUP

uiresume(handles.figure);


% --- Executes during object creation, after setting all properties.
function figure_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



function biastime_Callback(hObject, eventdata, handles)
% hObject    handle to biastime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of biastime as text
%        str2double(get(hObject,'String')) returns contents of biastime as a double


% --- Executes during object creation, after setting all properties.
function biastime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to biastime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when user attempts to close figure.
function figure_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
uiresume(handles.figure);


