function mswp = write_mdif(msweep,fname,varargin)
%WRITE_MDIF    Writes an meassweep object into a generic MDIF file.
%   write_mdif(meassweep_obj,filename,'Prop1','val1','Prop2','val2',...), specifies different options used during the conversion process.
%   Valid properties and are:
%   'BlockName' :   Name of the MDIF block to write default: 'meassweep')
%   'FreqName'  :   Name of the frequency variable (default: 'freq')
%   'IndepNames':   List of independent variable names e.g. {'vgs','vds'} (default: '')
%   'DepNames'  :   List of names of dependent variable names to write into the file (default: All variables defined)
%
%   Typical example of usage: 
%   write_mdif(meassweep_obj,filename,'BlockName','LDMOS69','IndepNames',{'Vgs','Vds'});


% $Header$
% $Author$
% $Date$
% $Revision$ 
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

% Create a file for text formatted input.
fid = fopen(fname,'wt');


property_argin = varargin;

% Parse the input arguments
prop_names = {'IndepNames','DepNames','BlockName'};
prop_vals  = {'','','meassweep'};
if nargin>3   %set(cIN,'Prop1',val,'Prop2',val2,...)
    if mod(nargin,2)~=0, error('Illegal input argument format'); end
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
    % Assign something reasonable
    for k = 1:length(mstate_names)
        val = unique(get(msweep,mstate_names{k}));
        if length(val)>1  & ~ischar(val)
            indep_names = {indep_names{:},mstate_names{k}};
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

dep_type = {};
format_str = '% freq(real)';
data_matrix = [];
data_matrix(:,1) = get(msweep.data{1},'Freq');
fprint_str = '';
nports = size(get(msweep.data{1},'mtrx'),1);
for n = 1:length(msweep)
    fprintf(fid,'\n');
    for k = 1:length(indep_names)
        tmp = get(msweep.data{n},indep_names{k});
        if isa(tmp,'double') & length(tmp)==1
            fprintf(fid,'VAR %s(real) = %f\n',indep_names{k},tmp);
        else
            error('Illegal %s value',indep_names{k});
        end
    end
    % Start the block...
    fprintf(fid,'BEGIN %s\n',block_name);
    for k = 1:length(dep_names)
        this_name = dep_names{k};
        tmp = get(msweep.data{n},this_name);
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
    % Define frequency dependent data format string
    col = 2;
    for nx = 1:nports
        for ny = 1:nports
            if n == 1, 
                format_str = sprintf('%s S[%d,%d](complex)',format_str,nx,ny); 
            end
            spname = sprintf('S%d%d',nx,ny);
            tmp_data = get(msweep.data{n},spname);
            data_matrix(:,col) = real(tmp_data);
            data_matrix(:,col+1) = imag(tmp_data);
            col = col + 2;
        end
    end
    fprintf(fid,'%s\n',format_str);
    fprint_str = repmat(['%g\t'],1,size(data_matrix,2));
    fprint_str = strcat(fprint_str(1:end-2),'\n');
    fprintf(fid,fprint_str,data_matrix.');
    fprintf(fid,'END\n');
end
fclose(fid);