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
% $Author: fager $
% $Date: 2005-03-24 13:23:45 +0100 (Thu, 24 Mar 2005) $
% $Revision: 250 $ 
% $Log$
% Revision 1.1  2005/03/24 12:23:45  fager
% First version
%

% Create a file for text formatted input.
fid = fopen(fname,'wt');


property_argin = varargin;

% Parse the input arguments
prop_names = {'IndepNames','FreqName','DepNames','BlockName'};
prop_vals  = {'','freq','','meassweep'};
if length(property_argin) == 0, % Display MDIF info
    [blocknames,blockdata] = read_mdif_file(fname);
    for k = 1:length(blocknames)
        disp(['Block: ',blocknames{k}]);
        disp(sprintf('\t%s','VAR-names:'));
        for n = 1:length(blockdata(k).var_names);
            disp(sprintf('\t\t%s',blockdata(k).var_names{n}));
        end
        disp(sprintf('\t%s','DEP-names:'));
        for n = 1:length(blockdata(k).dep_names);
            disp(sprintf('\t\t%s',blockdata(k).dep_names{n}));
        end
    end
    return;
elseif nargin>3 & mod(nargin,2)==0   %set(cIN,'Prop1',val,'Prop2',val2,...)
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
    error('Illegal number of input arguments');
end

indep_names = prop_vals{1};
freq_name = prop_vals{2};
dep_names = prop_vals{3};
mstate_names = get(get(msweep.data{1},'measstate'));
block_name = prop_vals{4};

if ~all(ismember(indep_names,mstate_names))
    error('The independent parameter names given are not valid.');
end
if ~ismember(upper(freq_name),upper(mstate_names))
    error('The freq-name given is not valid.');
end
if ~(all(ismember(dep_names,mstate_names)) | isempty(dep_names))
    error('The dependent parameter names given are not valid.');
end
if isempty(dep_names)
    dep_names = mstate_names;
    other_ix = find(ismember(upper(mstate_names),upper({indep_names{:},freq_name})));
    dep_names(other_ix) = [];
end

% Start by writing some comment lines.
tmp_msmnt = get(msweep.data{1},'measmnt');
msmnt_names = get(tmp_msmnt);
for k = 1:length(msmnt_names)
    fprintf(fid,'! %s\t: %s\n',msmnt_names{k},get(tmp_msmnt,msmnt_names{k}));
end

format_str = '% freq(real)';
dep_type = {};
data_matrix = [];
data_matrix(:,1) = get(msweep.data{1},freq_name);
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
    % Define data format string
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
    for k = 1:length(dep_names)
        this_name = dep_names{k};
        tmp = get(msweep.data{n},this_name);
        if n == 1
            if ~isnumeric(tmp), error('Dependent data must be numeric'); end
            if isreal(get(msweep,this_name))
                dep_type{k} = 'real';
                format_str = sprintf('%s %s(real)',format_str,this_name);
            else
                dep_type{k} = 'complex';
                format_str = sprintf('%s %s(complex)',format_str,this_name);
            end
        end
        if length(tmp)==1
            tmp_data = repmat(tmp,size(data_matrix,1),1);
        elseif length(tmp) ~= size(data_matrix,1)
            error('Illegal data length for parameter %s',this_name);
        else
            tmp_data = tmp;
        end
        
        switch dep_type{k}
            case 'real'
                data_matrix(:,col) = tmp_data;
                col = col + 1;
            case 'complex'
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