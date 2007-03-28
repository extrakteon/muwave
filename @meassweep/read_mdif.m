function mswp = read_mdif(meassweep,fname,varargin)
%READ_MDIF    Reads a Generic MDIF file into an meassweep object.
%   read_mdif(meassweep,filename); Displays the blocks, varible and dependent parameter names found in "filename".
%
%   mswp = read_mdif(meassweep,filename,'Prop1','val1','Prop2','val2',...), specifies different options used during the conversion process.
%   Valid options and are:
%   'BlockName' :   Name of the MDIF block to read (default: '')
%   'FreqName'  :   Name of the frequency variable (default: '')
%   'SPName'    :   Name of the multi dimensional S (or Z,Y,T) variable (default: '')
%   'DepNames'  :   List of names of dependent variable names (default: '')
%   'Z0'        :   S-parameter system impedance (default: 50)
%   'SPType'    :   Type for S-parameter data; either of 'S','Z','Y', or 'T' (default: 'S');
%
%   Example of usage: 
%   mswp = read_mdif(meassweep,'testfile.mdif','BlockName','Spdata','FreqName','Sweep.Freq','SPName','S.m');

% $Header$
% $Author: fager $
% $Date: 2005-03-24 13:25:10 +0100 (Thu, 24 Mar 2005) $
% $Revision: 251 $ 
% $Log$
% Revision 1.6  2005/03/24 12:25:10  fager
% If only 1 block present, it will be automatically selected.
% Adds information about the original mdif file name to the meassp-objects created.
%
% Revision 1.5  2005/03/22 14:10:16  fager
% If a dependent variable is a vector of identical values, convert it to a scalar.
%
% Revision 1.4  2005/03/22 10:55:49  fager
% break -> return
%
% Revision 1.3  2005/03/22 00:36:27  fager
% First version
%

property_argin = varargin;

% Parse the input arguments
prop_names = {'BlockName','FreqName','SPName','DepNames','Z0','SPType'};
prop_vals  = {'','','',{},50,'S'};
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

% Assign the property values
blockname = prop_vals{1};
freqname = prop_vals{2};
spname = prop_vals{3};
depnames = cellstr(prop_vals{4});
Z0 = prop_vals{5};
sptype = prop_vals{6};

% Some useful states.
tmp_swp = meassweep;
tmp_msmnt = measmnt;


[blocknames,blockdata] = read_mdif_file(fname);
if (length(blocknames)==1 & isempty(blockname))
    block_ix = 1;
    tmp_msmnt = addprop(tmp_msmnt,'Blockname',blocknames{1});
else
    block_ix = find(ismember(blockname,blocknames));
    if isempty(block_ix), error('Blockname not properly defined');end
    tmp_msmnt = addprop(tmp_msmnt,'Blockname',blocknames{block_ix});
end
[pathstr,nm,ext,versn] = fileparts(fname);
if isempty(pathstr), pathstr = cd; end
tmp_msmnt = set(tmp_msmnt,'Origin',fullfile(pathstr,[nm ext versn]));

bdata = blockdata(block_ix);
sp_ix = find(ismember(bdata.dep_names,spname));
freq_ix = find(ismember(bdata.dep_names,freqname));

if ~isempty(depnames)
    for k = 1:length(depnames)
        dix = find(ismember(bdata.dep_names,depnames{k}));
        if isempty(dix), 
            error('Illegal dependent parameter name');
        else
            dep_ix(k) = dix;
        end
    end
end

for n_meas = 1:size(bdata.var_values,2)
    tmp_state = measstate;
    tmp_msp = meassp;
    if ~isempty(sp_ix) % S-parameter data
        tmp_xp = xparam(bdata.dep_data{n_meas}{sp_ix},sptype,Z0);
        tmp_msp = set(tmp_msp,'Data',tmp_xp);
    end
    
    if ~isempty(freq_ix) % Frequency data
        tmp_state = addprop(tmp_state,'Freq',bdata.dep_data{n_meas}{freq_ix});
    end
    
    for k = 1:length(dep_ix) % General dependent data
        name = depnames{k};
        name = strrep(name,'.','_'); % Replace . with _ in variable names
        dataval = bdata.dep_data{n_meas}{dep_ix(k)};
        if length(unique(dataval)) == 1,
            dataval = dataval(1);
        end
        tmp_state = addprop(tmp_state,name,dataval);
    end
    
    for k = 1:length(bdata.var_names)
        name = bdata.var_names{k};
        if strncmpi(name,'SWEEP.',6),
            name = name(7:end);
        end
        name = strrep(name,'.','_'); % Replace . with _ in variable names
        tmp_state = addprop(tmp_state,name,bdata.var_values(k,n_meas));
    end
    
    % Assign the measstate-object
    tmp_msp = set(tmp_msp,'measstate',tmp_state);
    % Assign the measmnt-object
    tmp_msp = set(tmp_msp,'measmnt',tmp_msmnt);            
    % Assign the meassp-object
    tmp_swp = add(tmp_swp,tmp_msp);
end
mswp = tmp_swp;