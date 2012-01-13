function handles = LoadSetup(handles,MEAS)
% load file
try
    if handles.SETUP.AUTO
        load(handles.SETUP.BIASFILE);
    else
        [file,path] = uigetfile('setup/*.mat','Open setup file');
        load(fullfile(path,file)); 
    end
    
       
    
    % clear bias setup
    set(handles.v1start,'String','0');
    set(handles.v1stop,'String','0');
    set(handles.v1step,'String','0');
    set(handles.i1comp,'String','0');
    set(handles.p1comp,'String','0');
    set(handles.v2start,'String','0');
    set(handles.v2stop,'String','0');
    set(handles.v2step,'String','0');
    set(handles.i2comp,'String','0');
    set(handles.p2comp,'String','0');

    % update list in "Bias grid"
    set(handles.biasgrid,'String',DATA.BIASGRID);
    set(handles.biasgrid,'Value',DATA.NUM_BIAS); % select last point
    
    % load bias points
    handles.bias = DATA.BIAS;
    
    % update the numer of regions
    handles.num_regions = DATA.NUM_REGIONS;
    
    % update the numer of bias points
    handles.numGL = DATA.NUM_GL;
    
    % update the numer of bias points
    handles.numMEAS = DATA.NUM_MEAS;
    
    % update the numer of bias points
    handles.numBIAS = DATA.NUM_BIAS;
    
    % set mode
    set(handles.RadioV1, 'Value', DATA.RADIOV1_SELECTED);
    set(handles.RadioV2, 'Value', ~DATA.RADIOV1_SELECTED);
    set(handles.removeDuplicates, 'Value', DATA.REMOVE_DUP_SELECTED);

    % load lsna specific settings
    if strcmp(DATA.MEAS,'LSNA')
        % update power
        set(handles.Pstart,'String',DATA.PSTART);
        set(handles.Pstop,'String',DATA.PSTOP);
        set(handles.Pstep,'String',DATA.PSTEP);

        % update GL
        % get grid data
        h = get(handles.smith, 'Children');
        
        handles.GL = DATA.GL; % update fundamental
        set(h(2),'UserData',1:handles.numGL);
        set(h(2),'XData',real(handles.GL));
        set(h(2),'YData',imag(handles.GL));
        
        if DATA.NUMMOD == 2 % update 2nd harmnoic
            handles.GL2 = DATA.GL2;
            set(h(3),'UserData',1:handles.numGL);
            set(h(3),'XData',real(handles.GL2));
            set(h(3),'YData',imag(handles.GL2));            
        end        

        % Update Load reflection list
        set(handles.loadgrid,'String',num2str(handles.GL));
        % update gl counter
        set(handles.cgl,'String',num2str(handles.numGL));
        % update bias counter
        set(handles.cbias,'String',num2str(handles.numBIAS));         
    else
        handles.numGL = 0;
        % update counter text
        ctext = sprintf('Point 0 out of %s',num2str(handles.numMEAS));
        set(handles.countertext,'String',ctext);        
    end  
catch
end