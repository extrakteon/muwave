function handles = changeBias(handles, region)
%CHANGEBIAS Alter witch grid that is choosen as individual
    
    try handles = writeBiasList(handles, region);
       
        DC1 = handles.instr.measure_dc1;
        DC2 = handles.instr.measure_dc2;
        
        if strcmp(strtrim(handles.bias.name{region}), '')
            gridName = '[Grid name]';
        else
            gridName = handles.bias.name{region};
        end
        
        set(handles.editGridname, 'String', gridName);
        
        if DC1 

            v1 = handles.bias.v1{region};
            i1 = handles.bias.i1{region};
            p1 = handles.bias.p1{region};
            
            if isempty(diff(v1))
                step1 = v1(end);
            else
                step1 = median(diff(v1));
            end
            
            set(handles.v1start,'String', num2str(v1(1)));
            set(handles.v1stop,'String', num2str(v1(end)));
            set(handles.v1step,'String', num2str(step1));
            set(handles.p1comp,'String', num2str(p1));
            set(handles.i1comp,'String', num2str(i1));
            
        end    
           
        
        if DC2
            
            v2 = handles.bias.v2{region};
            i2 = handles.bias.i2{region};
            p2 = handles.bias.p2{region};
            
            if isempty(diff(v2))
                step2 = v2(end);
            else
                step2 = median(diff(v2));
            end
                
                       
            set(handles.v2start,'String', num2str(v2(1)));
            set(handles.v2stop,'String', num2str(v2(end)));
            set(handles.v2step,'String', num2str(step2));
            set(handles.p2comp,'String', num2str(p2));
            set(handles.i2comp,'String', num2str(i2));
        
        end
        
           
        
        
    end
    
    

end

