function output = normalize_transistorparam(size,parameter,type)
        if strcmpi(type,'C') || strcmpi(type,'capacitor') || strcmpi(type,'cap')
            output = parameter/size; % Output example: F/mm
        elseif strcmpi(type,'L') || strcmpi(type,'inductor') || strcmpi(type,'inductance')
            output = parameter*size; % Output example: H*mm
        elseif strcmpi(type,'R') || strcmpi(type,'resistor') || strcmpi(type,'resistance')
            output = parameter*size; % Output example: Ohm*mm
        elseif strcmpi(type,'gm') || strcmpi(type,'transconductance')
            output = parameter/size; % Output example: S/mm 
        elseif strcmpi(type,'gd') || strcmpi(type,'output conductance')
            output = parameter/size; % Output example: S/mm     
        else
            output = parameter;
            warndlg(['The parameter ' type ' could not be scaled'])
        end
            
            
       