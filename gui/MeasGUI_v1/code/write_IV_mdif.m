function mswp = write_IV_mdif(msweep, fname, handles, varargin)
%WRITE_MDIF    Writes an meassweep object into a generic MDIF file.
%   write_IV_mdif(meassweep_obj,filename, handles, 'Prop1','val1','Prop2','val2',...), specifies different options used during the conversion process.
%   Valid properties and are:
%   'BlockName' :   Name of the MDIF block to write default: 'meassweep')
%   'FreqName'  :   Name of the frequency variable (default: 'freq')
%   'IndepNames':   List of independent variable names e.g. {'V1','V1_SET'} (default: '') 
%   'DepNames'  :   List of names of dependent variable names to write into the file (default: All variables defined)
%
%   Typical example of usage: 
%   write_mdif(meassweep_obj,filename, handles, 'BlockName','LDMOS69','IndepNames',{'V1','V1_SET'});


% $Header$
% $Author: fager $
% $Date: 2005-05-12 16:58:20 +0200 (Thu, 12 May 2005) $
% $Revision: 283 $ 
% $Log$
% Revision 1.3  2005/05/12 14:57:44  fager
% Makes use of attributes
%
% Revision 1.2  2005/05/12 13:27:50  fager
% Now working...
% Now makes use of attributes
%
% Revision 1.1  2005/03/24 12:23:45  fager
% First version
%


DC1 = handles.instr.measure_dc1;
DC2 = handles.instr.measure_dc2;

% Create a file for text formatted input.
fid = fopen(fname,'wt');


property_argin = varargin;

% Parse the input arguments
prop_names = {'IndepNames','DepNames','BlockName'};
prop_vals  = {'','','meassweep'};
if nargin-1>3   %set(cIN,'Prop1',val,'Prop2',val2,...)
    if mod(nargin-1,2)~=0, error('Illegal input argument format'); end
    while length(property_argin) >= 2
        prop = property_argin{1};
        prop_ix = find(strcmpi(prop_names,prop));
        val = property_argin{2};
        property_argin = property_argin(3:end);
        if ~isstr(prop), error('Properties must be strings.'), end;
        if isempty(val), continue; end;
        if isempty(prop_ix) % New, unknown property
            error('Illegal property: %s',prop);
        else % 
            prop_vals{prop_ix} = val;
        end
    end
else
end

indep_names = prop_vals{1};
dep_names = prop_vals{2};
mstate_names = get(get(msweep.data{1},'measstate'));
block_name = prop_vals{3};

if isempty(indep_names),
    indep_names = {};
    
    % Assign independent names (main sweep variable) according to what have been measured
    if DC1 && DC2
        if get(handles.RadioV1, 'Value')
            indep_names = {'V1_SET'};
        else
            indep_names = {'V2_SET'};
        end       
    end
end


if ~all(ismember(indep_names,mstate_names))
    error('The independent parameter names given are not valid.');
end
if ~iscell(indep_names), indep_names = {indep_names}; end
if ~(all(ismember(dep_names,mstate_names)) | isempty(dep_names))
    error('The dependent parameter names given are not valid.');
end
if isempty(dep_names)
    dep_names = mstate_names;
    if ~iscell(dep_names), dep_names = {dep_names}; end
    other_ix = find(ismember(upper(mstate_names),upper({indep_names{:}})));
    dep_names(other_ix) = [];
end

% Start by writing some comment lines.
tmp_msmnt = get(msweep.data{1},'measmnt');
msmnt_names = get(tmp_msmnt);
for k = 1:length(msmnt_names)
    fprintf(fid,'! %s\t: %s\n',msmnt_names{k},get(tmp_msmnt,msmnt_names{k}));
end



% This sets the sub sweep variable and what variables that are read
str_sweep_var = '';
read_names = {};



% Checks if the sweep is a multisweep and alter the string variables
radio_check = get(handles.RadioV1, 'Value');
if ~(DC1 && DC2)
    radio_check = ~radio_check;
end

if radio_check
    str_sweep_var = 'V2_SET';
    read_names = {'V2', 'I2'};
    if (DC1 && DC2)
        read_names{3} = 'I1';
        read_names{4} = 'V1';
    end
else 
    str_sweep_var = 'V1_SET';
    read_names = {'V1', 'I1'};
    if (DC1 && DC2)
        read_names{2} = 'I2';
        read_names{3} = 'I1';
        read_names{4} = 'V2';
    end
end


% Removes read_names from dep_names
tmp_names = [dep_names, read_names, str_sweep_var, indep_names];
[trashValue, unique_idx, tmp_idx] = unique(tmp_names, 'last');
tmp_list = {};
unique_idx = sort(unique_idx);
id = 1;
for new_idx = unique_idx
    if new_idx > length(dep_names)
        break;
    else
        tmp_list{id} = dep_names{new_idx};
        id = id + 1;
    end
end

dep_names = tmp_list;
    



idx_head_sweep = 1;
if DC1 & DC2
    [trashValue1, unique_idx, trashValue2] = unique(get(msweep, indep_names{1}), 'first');
    idx_head_sweep = sort(unique_idx);
end


fprint_str = '';  


for n = 1:length(idx_head_sweep) 
    fprintf(fid,'\n');
    for k = 1:length(indep_names)
        tmp = get(msweep.data{idx_head_sweep(n)},indep_names{k});
        if isa(tmp,'double') & length(tmp)==1
            fprintf(fid,'VAR %s(real) = %f\n',indep_names{k},tmp);
        else
            error('Illegal %s value',indep_names{k});
        end
    end
    
    dep_type = {};
    format_str = horzcat('% ', str_sweep_var);
    data_matrix = [];
    tmp_data = get(msweep, str_sweep_var);
    if n < length(idx_head_sweep)
        data_matrix(:,1) = tmp_data(idx_head_sweep(n):idx_head_sweep(n+1)-1);
    else
        data_matrix(:,1) = tmp_data(idx_head_sweep(n):end);
    end

        
    % Start the block...
    fprintf(fid,'BEGIN %s\n',block_name);
    dep_names = {}; % Supresses the additional information at the BEGIN
    for k = 1:length(dep_names)
        this_name = dep_names{k};
        tmp = get(msweep.data{idx_head_sweep(n)},this_name);
        if isnumeric(tmp) & (length(tmp) == 1),
            if isreal(tmp)
                formatstr = 'real';
                tmp = num2str(tmp);
            else
                formatstr = 'real';
            end
        elseif isstr(tmp)
            formatstr = 'string';
            tmp = strcat('"',tmp,'"');
        else
            warning('Unsupported parameter format: %s',this_name);
        end
        fprintf(fid,'# %s(%s) = %s\n',this_name,formatstr,tmp);
    end
    
    % Executes the block loop
    
    col = 2;
    for name = read_names
        
        tmp_data = get(msweep, name{1});
        
        if n < length(idx_head_sweep)
            tmp_data = tmp_data(idx_head_sweep(n):idx_head_sweep(n+1)-1);
        else
            tmp_data = tmp_data(idx_head_sweep(n):idx_head_sweep(n)+size(data_matrix, 1)-1);
        end
        
        data_matrix(:,col) = real(tmp_data);
        col = col + 1;
    end
    
    if (DC1 && DC2)
        addString = '%s(real)';
    else
        addString = '';
    end
    format_str = sprintf(['%s(real) %s(real) %s(real) %s(real) ', addString],...
    format_str, read_names{:}); 
    fprintf(fid,'%s\n',format_str);
    fprint_str = repmat(['%g\t'],1,size(data_matrix,2));
    fprint_str = strcat(fprint_str(1:end-2),'\n');
    fprintf(fid,fprint_str,data_matrix.');
    fprintf(fid,'END\n');
end
fclose(fid);