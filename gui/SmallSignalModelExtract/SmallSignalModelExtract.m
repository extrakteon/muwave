function varargout = SmallSignalModelExtract(varargin)
%% INITIALISE
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SmallSignalModelExtract_OpeningFcn, ...
                   'gui_OutputFcn',  @SmallSignalModelExtract_OutputFcn, ...
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

function SmallSignalModelExtract_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

function varargout = SmallSignalModelExtract_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;


function filepath_Callback(hObject, eventdata, handles)

function filepath_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function browsebuttond_Callback(hObject, eventdata, handles)
%% BROWSE
filepath = get(handles.filepath,'String');
[FileName PathName] = uigetfile('*.mat','Select the measurement file',filepath);
set(handles.filepath,'String',[PathName FileName]);
set(handles.filepath,'TooltipString',[PathName FileName]);
guidata(hObject, handles);


function loadbutton_Callback(hObject, eventdata, handles)
%% Load
filepath = get(handles.filepath,'String');
sweep = load(filepath);
all_sweeps = sweep.swp;
f=all_sweeps.freq(:,1);
userdata.all_sweeps = all_sweeps;
set(handles.figure1,'Userdata',userdata);

% Extraction frequencies
LF1_want = str2num(get(handles.edit_LF1,'String'));
LF2_want = str2num(get(handles.edit_LF2,'String'));
HF1_want = str2num(get(handles.edit_HF1,'String'));
HF2_want = str2num(get(handles.edit_HF2,'String'));
[idxLF1, idxLF1] = min(abs(f-LF1_want*1e9));
[idxLF2, idxLF2] = min(abs(f-LF2_want*1e9));
[idxHF1, idxHF1] = min(abs(f-HF1_want*1e9));
[idxHF2, idxHF2] = min(abs(f-HF2_want*1e9));
set(handles.edit_LF1,'String',num2str(f(idxLF1)/1e9));
set(handles.edit_LF2,'String',num2str(f(idxLF2)/1e9));
set(handles.edit_HF1,'String',num2str(f(idxHF1)/1e9));
set(handles.edit_HF2,'String',num2str(f(idxHF2)/1e9));

% Pad capacitor bias
Vgs_propose = min(unique(all_sweeps.V1_SET));
Vgs_value = find(unique(all_sweeps.V1_SET)'==Vgs_propose);
Vds_propose = min(unique(all_sweeps.V2_SET(all_sweeps.V1_SET==Vgs_propose)));
Vds_value = find(unique(all_sweeps.V2_SET)'==Vds_propose);
set(handles.pop_padcap_Vg,'String',num2str(unique(all_sweeps.V1_SET)'));
set(handles.pop_padcap_Vg,'Value',Vgs_value);
set(handles.pop_padcap_Vd,'String',num2str(unique(all_sweeps.V2_SET)'));
set(handles.pop_padcap_Vg,'Value',Vds_value);

% Cold FET bias
Vgs_propose = max(unique(all_sweeps.V1_SET));
Vgs_value = find(unique(all_sweeps.V1_SET)'==Vgs_propose);
Vds_propose = min(unique(all_sweeps.V2_SET(all_sweeps.V1_SET==Vgs_propose)));
Vds_value = find(unique(all_sweeps.V2_SET)'==Vds_propose);
set(handles.pop_coldfet_Vg,'String',num2str(unique(all_sweeps.V1_SET)'));
set(handles.pop_coldfet_Vg,'Value',Vgs_value);
set(handles.pop_coldfet_Vd,'String',num2str(unique(all_sweeps.V2_SET)'));
set(handles.pop_coldfet_Vd,'Value',Vds_value);

% Enable Pad Extraction
set(handles.pop_padcap_Vg,'Enable','on')
set(handles.pop_padcap_Vd,'Enable','on')
set(handles.check_padcap_combinations,'Enable','on')
set(handles.check_padcap_plot,'Enable','on')
set(handles.push_extract_pad,'Enable','on')

guidata(hObject, handles);


function pop_padcap_Vd_Callback(hObject, eventdata, handles)

function pop_padcap_Vd_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function pop_padcap_Vg_Callback(hObject, eventdata, handles)
userdata = get(handles.figure1,'Userdata');
all_sweeps = userdata.all_sweeps;
if get(handles.check_padcap_combinations,'Value');
    Vgs_value = get(handles.pop_padcap_Vg,'Value');
    Vgs = unique(all_sweeps.V1_SET)';
    Vgs = Vgs(Vgs_value);
    Vds_possible = unique(all_sweeps.V2_SET(all_sweeps.V1_SET==Vgs)');
    set(handles.pop_padcap_Vd,'String',num2str(Vds_possible));
    if get(handles.pop_padcap_Vd,'Value')>length(Vds_possible)
        set(handles.pop_padcap_Vd,'Value',length(Vds_possible))
    end
else
    set(handles.pop_padcap_Vd,'String',num2str(unique(all_sweeps.V2_SET)'));
end


function pop_padcap_Vg_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function check_padcap_combinations_Callback(hObject, eventdata, handles)   
userdata = get(handles.figure1,'Userdata');
all_sweeps = userdata.all_sweeps;
if get(handles.check_padcap_combinations,'Value');
    Vgs_value = get(handles.pop_padcap_Vg,'Value');
    Vgs = unique(all_sweeps.V1_SET)';
    Vgs = Vgs(Vgs_value);
    Vds_possible = unique(all_sweeps.V2_SET(all_sweeps.V1_SET==Vgs)');
    set(handles.pop_padcap_Vd,'String',num2str(Vds_possible));
    if get(handles.pop_padcap_Vd,'Value')>length(Vds_possible)
        set(handles.pop_padcap_Vd,'Value',length(Vds_possible))
    end
else
    set(handles.pop_padcap_Vd,'String',num2str(unique(all_sweeps.V2_SET)'));
end



function slider1_Callback(hObject, eventdata, handles)

function slider1_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function edit_LF1_Callback(hObject, eventdata, handles)
%% LF1
userdata = get(handles.figure1,'Userdata');
all_sweeps = userdata.all_sweeps;
f = all_sweeps.freq(:,1);
LF1_want = str2num(get(handles.edit_LF1,'String'));
[idxLF1, idxLF1] = min(abs(f-LF1_want*1e9));
set(handles.edit_LF1,'String',num2str(f(idxLF1)/1e9));


function edit_LF1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_LF2_Callback(hObject, eventdata, handles)
%% LF2
userdata = get(handles.figure1,'Userdata');
all_sweeps = userdata.all_sweeps;
f = all_sweeps.freq(:,1);
LF2_want = str2num(get(handles.edit_LF2,'String'));
[idxLF2, idxLF2] = min(abs(f-LF2_want*1e9));
set(handles.edit_LF2,'String',num2str(f(idxLF2)/1e9));


function edit_LF2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_HF1_Callback(hObject, eventdata, handles)
%% HF1
userdata = get(handles.figure1,'Userdata');
all_sweeps = userdata.all_sweeps;
f = all_sweeps.freq(:,1);
HF1_want = str2num(get(handles.edit_HF1,'String'));
[idxHF1, idxHF1] = min(abs(f-HF1_want*1e9));
set(handles.edit_HF1,'String',num2str(f(idxHF1)/1e9));


function edit_HF1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_HF2_Callback(hObject, eventdata, handles)
%% HF2
userdata = get(handles.figure1,'Userdata');
all_sweeps = userdata.all_sweeps;
f = all_sweeps.freq(:,1);
HF2_want = str2num(get(handles.edit_HF2,'String'));
[idxHF2, idxHF2] = min(abs(f-HF2_want*1e9));
set(handles.edit_HF2,'String',num2str(f(idxHF2)/1e9));


function edit_HF2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function push_extract_pad_Callback(hObject, eventdata, handles)
%% Calculate Pad Capacitors
plotmode = get(handles.check_padcap_plot,'Value'); %0 = off, 1 = on
userdata = get(handles.figure1,'Userdata');
all_sweeps = userdata.all_sweeps;
f=all_sweeps.freq(:,1);
size = str2num(get(handles.edit_gatewidth,'String'))/1000; % Size in mm.
if isempty(size)
    size = 0;
end

% Frequency span for extracting data
LF1 = str2num(get(handles.edit_LF1,'String'));
LF2 = str2num(get(handles.edit_LF2,'String'));
HF1 = str2num(get(handles.edit_HF1,'String'));
HF2 = str2num(get(handles.edit_HF2,'String'));
[idxLF1, idxLF1] = min(abs(f-LF1*1e9));
[idxLF2, idxLF2] = min(abs(f-LF2*1e9));
[idxHF1, idxHF1] = min(abs(f-HF1*1e9));
[idxHF2, idxHF2] = min(abs(f-HF2*1e9));

% Calculating Pad Capacitors
Vgs_value = get(handles.pop_padcap_Vg,'Value');
Vgs_list = str2num(get(handles.pop_padcap_Vg,'String'));
Vgs = Vgs_list(Vgs_value);
Vds_value = get(handles.pop_padcap_Vd,'Value');
Vds_list = str2num(get(handles.pop_padcap_Vd,'String'));
Vds = Vds_list(Vds_value);

PinchOff = SweepSelect(all_sweeps,Vgs,Vds,0);
[Cpg Cpd] = ParasiticCapacitor(PinchOff,idxLF1,idxLF2,plotmode); % This will give you the start value for optimization in ADS
userdata.Cpg = Cpg;
userdata.Cpd = Cpd;
userdata.PinchOff = PinchOff;
set(handles.figure1,'Userdata',userdata);

% Enable Cold FET
set(handles.pop_coldfet_Vg,'Enable','on')
set(handles.pop_coldfet_Vd,'Enable','on')
set(handles.check_coldfet_combinations,'Enable','on')
set(handles.check_coldfet_plot,'Enable','on')
set(handles.edit_coldfet_Rg,'Enable','on')
set(handles.edit_coldfet_Rc,'Enable','on')
set(handles.edit_coldfet_iterations,'Enable','on')
set(handles.push_coldfet_extract,'Enable','on')

guidata(hObject, handles);

function check_padcap_plot_Callback(hObject, eventdata, handles)



function edit_gatewidth_Callback(hObject, eventdata, handles)
size = str2num(get(handles.edit_gatewidth,'String'));
if isempty(size)
    set(handles.edit_gatewidth,'String','');
end
guidata(hObject, handles);




function edit_gatewidth_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function pop_coldfet_Vg_Callback(hObject, eventdata, handles)
userdata = get(handles.figure1,'Userdata');
all_sweeps = userdata.all_sweeps;
if get(handles.check_coldfet_combinations,'Value');
    Vgs_value = get(handles.pop_coldfet_Vg,'Value');
    Vgs = unique(all_sweeps.V1_SET)';
    Vgs = Vgs(Vgs_value);
    Vds_possible = unique(all_sweeps.V2_SET(all_sweeps.V1_SET==Vgs)');
    set(handles.pop_coldfet_Vd,'String',num2str(Vds_possible));
    if get(handles.pop_coldfet_Vd,'Value')>length(Vds_possible)
        set(handles.pop_coldfet_Vd,'Value',length(Vds_possible))
    end
else
    set(handles.pop_coldfet_Vd,'String',num2str(unique(all_sweeps.V2_SET)'));
end



function pop_coldfet_Vg_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function pop_coldfet_Vd_Callback(hObject, eventdata, handles)


function pop_coldfet_Vd_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function check_coldfet_combinations_Callback(hObject, eventdata, handles)
userdata = get(handles.figure1,'Userdata');
all_sweeps = userdata.all_sweeps;
if get(handles.check_coldfet_combinations,'Value');
    Vgs_value = get(handles.pop_coldfet_Vg,'Value');
    Vgs = unique(all_sweeps.V1_SET)';
    Vgs = Vgs(Vgs_value);
    Vds_possible = unique(all_sweeps.V2_SET(all_sweeps.V1_SET==Vgs)');
    set(handles.pop_coldfet_Vd,'String',num2str(Vds_possible));
    if get(handles.pop_coldfet_Vd,'Value')>length(Vds_possible)
        set(handles.pop_coldfet_Vd,'Value',length(Vds_possible))
    end
else
    set(handles.pop_coldfet_Vd,'String',num2str(unique(all_sweeps.V2_SET)'));
end



function check_coldfet_plot_Callback(hObject, eventdata, handles)

function edit_coldfet_Rg_Callback(hObject, eventdata, handles)

function edit_coldfet_Rg_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_coldfet_Rc_Callback(hObject, eventdata, handles)


function edit_coldfet_Rc_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_coldfet_iterations_Callback(hObject, eventdata, handles)



function edit_coldfet_iterations_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function push_coldfet_extract_Callback(hObject, eventdata, handles)
%% Calculate Cold FET
userdata = get(handles.figure1,'Userdata');
all_sweeps = userdata.all_sweeps;
f=all_sweeps.freq(:,1);
size = str2num(get(handles.edit_gatewidth,'String'))/1000; % Size in mm.
if isempty(size)
    size = 0;
end

Rg = str2num(get(handles.edit_coldfet_Rg,'String'));
Rc = str2num(get(handles.edit_coldfet_Rc,'String'));
Cpg = userdata.Cpg;
Cpd = userdata.Cpd;
max_iterations = str2num(get(handles.edit_coldfet_iterations,'String'));
plotmode = get(handles.check_coldfet_plot,'Value'); %0 = off, 1 = on

% Frequency span for extracting data
LF1 = str2num(get(handles.edit_LF1,'String'));
LF2 = str2num(get(handles.edit_LF2,'String'));
HF1 = str2num(get(handles.edit_HF1,'String'));
HF2 = str2num(get(handles.edit_HF2,'String'));
[idxLF1, idxLF1] = min(abs(f-LF1*1e9));
[idxLF2, idxLF2] = min(abs(f-LF2*1e9));
[idxHF1, idxHF1] = min(abs(f-HF1*1e9));
[idxHF2, idxHF2] = min(abs(f-HF2*1e9));

% Bias
Vgs_value = get(handles.pop_coldfet_Vg,'Value');
Vgs_list = str2num(get(handles.pop_coldfet_Vg,'String'));
Vgs = Vgs_list(Vgs_value);
Vds_value = get(handles.pop_coldfet_Vd,'Value');
Vds_list = str2num(get(handles.pop_coldfet_Vd,'String'));
Vds = Vds_list(Vds_value);

fwd_swp  = SweepSelect(all_sweeps,Vgs,Vds,0);
[Lg Ld Ls Rd Rs] = ...
     ParasiticLR(fwd_swp,Rg,Rc,Cpg,Cpd,idxLF1,idxLF2,idxHF1,idxHF2,max_iterations,plotmode);
 
% Save
userdata.Lg = Lg;
userdata.Ld = Ld;
userdata.Ls = Ls;
userdata.Rd = Rd;
userdata.Rs = Rs;
userdata.Rg = Rg;
userdata.fwd_swp = fwd_swp;
set(handles.figure1,'Userdata',userdata);

% Enable Cold FET
set(handles.check_intrinsic_plot,'Enable','on')
set(handles.push_extract_intrinsic,'Enable','on')

guidata(hObject, handles);



function check_intrinsic_plot_Callback(hObject, eventdata, handles)

function push_extract_intrinsic_Callback(hObject, eventdata, handles)
%% Extract Intrinsic FET

plotmode = get(handles.check_intrinsic_plot,'Value'); %0 = off, 1 = on
userdata = get(handles.figure1,'Userdata');
all_sweeps = userdata.all_sweeps;
active_sweep = all_sweeps(all_sweeps.V2_SET>0);
f = all_sweeps.freq(:,1);
Cpg = userdata.Cpg;
Cpd = userdata.Cpd;
Lg = userdata.Lg;
Ld = userdata.Ld;
Ls = userdata.Ls;
Rd = userdata.Rd;
Rs = userdata.Rs;
Rg = userdata.Rg;

% Frequency span for extracting data
LF1 = str2num(get(handles.edit_LF1,'String'));
LF2 = str2num(get(handles.edit_LF2,'String'));
HF1 = str2num(get(handles.edit_HF1,'String'));
HF2 = str2num(get(handles.edit_HF2,'String'));
[idxLF1, idxLF1] = min(abs(f-LF1*1e9));
[idxLF2, idxLF2] = min(abs(f-LF2*1e9));
[idxHF1, idxHF1] = min(abs(f-HF1*1e9));
[idxHF2, idxHF2] = min(abs(f-HF2*1e9));

intrinsic=meassweep;
modelsweep  = meassweep;
% Netlist for complete two ports
model = read_netlist(mna,'circuit1.net');
model = freq(model,f);

for k = 1:length(active_sweep)
    Deembed_swp = DeembedExtrinsic(active_sweep(k),Cpg,Cpd,Lg,Ld,Ls,Rg,Rd,Rs,1);
    intrinsic(k)=Deembed_swp;
    [Rj_Vector Cgd_Vector Ri_Vector Cgs_Vector Rds_Vector Cds_Vector gm_Vector tau_gm_Vector] = ...
        ExtractIntrinsicFET(Deembed_swp);
    % Save all the data
    Rj_data(:,k) = Rj_Vector;
    Cgd_data(:,k) = Cgd_Vector;
    Ri_data(:,k) = Ri_Vector;
    Cgs_data(:,k) = Cgs_Vector;
    Rds_data(:,k) = Rds_Vector;
    Cds_data(:,k) = Cds_Vector;
    gm_data(:,k) = gm_Vector;
    tau_gm_data(:,k) = tau_gm_Vector;
    
    % Save intrinsic elements
    Rj(k)     = max(MeanValue(Rj_Vector,  idxHF1, idxHF2), 0.1);
    Cgd(k)    = max(MeanValue(Cgd_Vector, idxLF1, idxLF2), 1e-15);
    Ri(k)     = max(MeanValue(Ri_Vector,  idxHF1, idxHF2), 0.1);
    Cgs(k)    = max(MeanValue(Cgs_Vector, idxLF1, idxLF2), 1e-15);
    Rds(k)    = max(MeanValue(Rds_Vector, idxLF1, idxLF2), 0.1);
    Cds(k)    = max(MeanValue(Cds_Vector, idxLF2, floor(idxHF1/2)), 1e-15);
    gm(k)     = MeanValue(gm_Vector,  idxLF1, idxLF2);
    tau_gm(k) = max(MeanValue(tau_gm_Vector, idxHF1, idxHF2), 1e-15);
    
    % Save the model
    [modelsweep(k), model] = SaveModel(active_sweep(k),model,Cpg,Lg,Rg,Cgs(k),Ri(k),Cgd(k),Rj(k),Rds(k),Cds(k),Rd,Cpd,Ld,Rs,Ls,gm(k),tau_gm(k));
    
    % Plot
    if plotmode ==1
        figure(10)
        PlotModelvsMeasurements(active_sweep(k),modelsweep(k),k)
        % Text
        txtstr = sprintf(' Cpg=%0.1f fF \n Cpd=%0.1f fF \n \n Lg=%0.1f pH \n Ls=%0.1f pH \n Ld=%0.1f pH \n Rg=%0.1f Ohm \n Rs=%0.1f Ohm \n Rd=%0.1f Ohm \n \n Cgs=%0.1f fF \n Cgd=%0.1f fF \n Cds=%0.1f fF \n Rds=%0.1f Ohm \n Rj=%0.1f Ohm \n Ri=%0.1f Ohm \n gds=%0.1f mS \n gm=%0.1f mS \n tau=%0.1f ps', ...
            Cpg*1e15, Cpd*1e15, ...
            Lg*1e12,Ls*1e12,Ld*1e12,Rg,Rs,Rd, ...
            Cgs(k)*1e15,Cgd(k)*1e15,Cds(k)*1e15,Rds(k),Rj(k),Ri(k),1/Rds(k)*1000,gm(k)*1000,tau_gm(k)*1e12);
        text(-2.35, 1.3, txtstr,'FontSize', 14, 'FontUnits', 'normalized');
    end
end

% Save
userdata.Rj = Rj;
userdata.Cgd = Cgd;
userdata.Ri = Ri;
userdata.Cgs = Cgs;
userdata.Rds = Rds;
userdata.Cds = Cds;
userdata.gm = gm;
userdata.tau_gm = tau_gm;

userdata.Rj_data = Rj_data;
userdata.Cgd_data = Cgd_data;
userdata.Ri_data = Ri_data;
userdata.Cgs_data = Cgs_data;
userdata.Rds_data = Rds_data;
userdata.Cds_data = Cds_data;
userdata.gm_data = gm_data;
userdata.tau_gm_data = tau_gm_data;

userdata.modelsweep = modelsweep;
userdata.active_sweep = active_sweep;

set(handles.figure1,'Userdata',userdata);

% Set default values for plot
set(handles.pop_plot_intvsfreq_Vg,'String',num2str(unique(active_sweep.V1_SET)'))
set(handles.pop_plot_intvsfreq_Vd,'String',num2str(unique(active_sweep.V2_SET)'))

% Enable PLOT
set(handles.pop_plot_intvsfreq_Vg,'Enable','on')
set(handles.pop_plot_intvsfreq_Vd,'Enable','on')
set(handles.push_plot_intvsfreq,'Enable','on')
set(handles.push_plot_sparam,'Enable','on')
set(handles.push_plot_parmvsVg,'Enable','on')
set(handles.push_plot_parmvsVd,'Enable','on')
set(handles.push_plot_parmvsId,'Enable','on')
set(handles.push_plot_parm3d,'Enable','on')

% Enable SAVE
set(handles.push_save_model,'Enable','on')

guidata(hObject, handles);

function push_plot_intvsfreq_Callback(hObject, eventdata, handles)
%% Plot intrinsic parameter fit vs. frequency
userdata = get(handles.figure1,'Userdata');
active_sweep = userdata.active_sweep;
f = active_sweep.freq(:,1);
Rj_data = userdata.Rj_data;
Cgd_data = userdata.Cgd_data;
Ri_data = userdata.Ri_data;
Cgs_data = userdata.Cgs_data;
Rds_data = userdata.Rds_data;
Cds_data = userdata.Cds_data;
gm_data = userdata.gm_data;
tau_gm_data = userdata.tau_gm_data;

% Frequency span for extracting data
LF1 = str2num(get(handles.edit_LF1,'String'));
LF2 = str2num(get(handles.edit_LF2,'String'));
HF1 = str2num(get(handles.edit_HF1,'String'));
HF2 = str2num(get(handles.edit_HF2,'String'));
[idxLF1, idxLF1] = min(abs(f-LF1*1e9));
[idxLF2, idxLF2] = min(abs(f-LF2*1e9));
[idxHF1, idxHF1] = min(abs(f-HF1*1e9));
[idxHF2, idxHF2] = min(abs(f-HF2*1e9));

% Bias
Vgs_value = get(handles.pop_plot_intvsfreq_Vg,'Value');
Vgs_list = str2num(get(handles.pop_plot_intvsfreq_Vg,'String'));
Vgs = Vgs_list(Vgs_value);
Vds_value = get(handles.pop_plot_intvsfreq_Vd,'Value');
Vds_list = str2num(get(handles.pop_plot_intvsfreq_Vd,'String'));
Vds = Vds_list(Vds_value);
swpNumber = find((round(active_sweep.V1_SET*100)/100==Vgs).*(round(active_sweep.V2_SET*100)/100==Vds),1); % Find the wanted sweep
if (swpNumber ~= 0)
    PlotIntrinsicFrequency(active_sweep(swpNumber),Rj_data(:,swpNumber),Cgd_data(:,swpNumber), ...
        Ri_data(:,swpNumber),Cgs_data(:,swpNumber),Rds_data(:,swpNumber),Cds_data(:,swpNumber), ...
        gm_data(:,swpNumber),tau_gm_data(:,swpNumber),idxLF1,idxLF2,idxHF1,idxHF2)
end
guidata(hObject, handles);


function pop_plot_intvsfreq_Vg_Callback(hObject, eventdata, handles)



function pop_plot_intvsfreq_Vg_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function pop_plot_intvsfreq_Vd_Callback(hObject, eventdata, handles)


function pop_plot_intvsfreq_Vd_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function push_plot_sparam_Callback(hObject, eventdata, handles)
%% Plot s-parameters
userdata = get(handles.figure1,'Userdata');
active_sweep = userdata.active_sweep;
modelsweep = userdata.modelsweep;
f = active_sweep.freq(:,1);

% Bias
Vgs_value = get(handles.pop_plot_intvsfreq_Vg,'Value');
Vgs_list = str2num(get(handles.pop_plot_intvsfreq_Vg,'String'));
Vgs = Vgs_list(Vgs_value);
Vds_value = get(handles.pop_plot_intvsfreq_Vd,'Value');
Vds_list = str2num(get(handles.pop_plot_intvsfreq_Vd,'String'));
Vds = Vds_list(Vds_value);
swpNumber = find((round(active_sweep.V1_SET*100)/100==Vgs).*(round(active_sweep.V2_SET*100)/100==Vds),1); % Find the wanted sweep

if (swpNumber ~= 0)
    figure(10)
    PlotModelvsMeasurements(active_sweep(swpNumber),modelsweep(swpNumber),swpNumber)
    % Text
    txtstr = sprintf(' Cpg=%0.1f fF \n Cpd=%0.1f fF \n \n Lg=%0.1f pH \n Ls=%0.1f pH \n Ld=%0.1f pH \n Rg=%0.1f Ohm \n Rs=%0.1f Ohm \n Rd=%0.1f Ohm \n \n Cgs=%0.1f fF \n Cgd=%0.1f fF \n Cds=%0.1f fF \n Rds=%0.1f Ohm \n Rj=%0.1f Ohm \n Ri=%0.1f Ohm \n gds=%0.1f mS \n gm=%0.1f mS \n tau=%0.1f ps', ...
        userdata.Cpg*1e15, userdata.Cpd*1e15, ...
        userdata.Lg*1e12,userdata.Ls*1e12,userdata.Ld*1e12,userdata.Rg,userdata.Rs,userdata.Rd, ...
        userdata.Cgs(swpNumber)*1e15,userdata.Cgd(swpNumber)*1e15,userdata.Cds(swpNumber)*1e15, ...
        userdata.Rds(swpNumber),userdata.Rj(swpNumber),userdata.Ri(swpNumber), ...
        1/userdata.Rds(swpNumber)*1000,userdata.gm(swpNumber)*1000,userdata.tau_gm(swpNumber)*1e12);
    text(-2.35, 1.3, txtstr,'FontSize', 14, 'FontUnits', 'normalized');
end
guidata(hObject, handles);

        
        
function push_plot_parmvsVg_Callback(hObject, eventdata, handles)
%% Plot intrinsic parameters vs. Vg
userdata = get(handles.figure1,'Userdata');
active_sweep = userdata.active_sweep;
Rj = userdata.Rj;
Cgd = userdata.Cgd;
Ri = userdata.Ri;
Cgs = userdata.Cgs;
Rds = userdata.Rds;
Cds = userdata.Cds;
gm = userdata.gm;
tau_gm = userdata.tau_gm;

size = str2num(get(handles.edit_gatewidth,'String'))/1000; % Size in mm.
if isempty(size)
    size = 0;
end

PlotIntrinsicBias(active_sweep,Rj,Cgd,Ri,Cgs,Rds,Cds,gm,tau_gm,size,'Vg');
guidata(hObject, handles);


function push_plot_parmvsVd_Callback(hObject, eventdata, handles)
%% Plot intrinsic parameters vs. Vg
userdata = get(handles.figure1,'Userdata');
active_sweep = userdata.active_sweep;
Rj = userdata.Rj;
Cgd = userdata.Cgd;
Ri = userdata.Ri;
Cgs = userdata.Cgs;
Rds = userdata.Rds;
Cds = userdata.Cds;
gm = userdata.gm;
tau_gm = userdata.tau_gm;

size = str2num(get(handles.edit_gatewidth,'String'))/1000; % Size in mm.
if isempty(size)
    size = 0;
end

PlotIntrinsicBias(active_sweep,Rj,Cgd,Ri,Cgs,Rds,Cds,gm,tau_gm,size,'Vd');
guidata(hObject, handles);

function push_plot_parmvsId_Callback(hObject, eventdata, handles)
%% Plot intrinsic parameters vs. Id
userdata = get(handles.figure1,'Userdata');
active_sweep = userdata.active_sweep;
Rj = userdata.Rj;
Cgd = userdata.Cgd;
Ri = userdata.Ri;
Cgs = userdata.Cgs;
Rds = userdata.Rds;
Cds = userdata.Cds;
gm = userdata.gm;
tau_gm = userdata.tau_gm;

size = str2num(get(handles.edit_gatewidth,'String'))/1000; % Size in mm.
if isempty(size)
    size = 0;
end

PlotIntrinsicBias(active_sweep,Rj,Cgd,Ri,Cgs,Rds,Cds,gm,tau_gm,size,'Id');
guidata(hObject, handles);

function push_plot_parm3d_Callback(hObject, eventdata, handles)
%% Plot intrinsic parameters in 3D
userdata = get(handles.figure1,'Userdata');
active_sweep = userdata.active_sweep;
Rj = userdata.Rj;
Cgd = userdata.Cgd;
Ri = userdata.Ri;
Cgs = userdata.Cgs;
Rds = userdata.Rds;
Cds = userdata.Cds;
gm = userdata.gm;
tau_gm = userdata.tau_gm;

size = str2num(get(handles.edit_gatewidth,'String'))/1000; % Size in mm.
if isempty(size)
    size = 0;
end

PlotIntrinsicBias(active_sweep,Rj,Cgd,Ri,Cgs,Rds,Cds,gm,tau_gm,size,'3D');
guidata(hObject, handles);


function push_save_model_Callback(hObject, eventdata, handles)
%% SAVE model parameters to mat-file

% get name of measurement file and append '_model' to file name
[PathName,FileName,Ext] = fileparts(get(handles.filepath,'String'));
FileName = strcat(FileName,'_model',Ext);
% open save file dialog
[FileName,PathName,FilterIndex] = uiputfile('*.mat','Save model parameters',fullfile(PathName,FileName));
% save
if FileName
    data = get(handles.figure1,'Userdata');
    save(fullfile(PathName,FileName),'data');
end 
guidata(hObject, handles);

