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
%   'AttrNames' :   List of names of attribute parameter names (default: '')
%   'Z0'        :   S-parameter system impedance (default: 50)
%   'SPType'    :   Type for S-parameter data; either of 'S','Z','Y', or 'T' (default: 'S');
%
%   Example of usage: 
%   mswp = read_mdif(meassweep,'testfile.mdif','BlockName','Spdata','FreqName','Sweep.Freq','SPName','S.m');

%   (c) Kristoffer Andersson & Christian Fager, Chalmers University of Technology, Sweden

% $Header$
% $Author: e7koffe $
% $Date: 2009-01-13 11:05:46 +0100 (ti, 13 jan 2009) $
% $Revision: 96 $ 
% $Log$
% Revision 1.10  2005/05/12 21:49:25  fager
% Fixed bugs relating to "intelligent" guesses of S-parameter and Frequency variable names.
%
% Revision 1.9  2005/05/12 14:58:03  fager
% *** empty log message ***
%
% Revision 1.8  2005/05/11 10:14:38  fager
% Erroneous command order
%
% Revision 1.7  2005/04/27 21:43:34  fager
% * Frequencies -> xparam
%
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
prop_names = {'BlockName','FreqName','SPName','DepNames','AttrNames','Z0','SPType'};
prop_vals  = {'','','',{},{},50,'S'};
if length(property_argin) == 0 & (nargout == 0), % Display MDIF info
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
        disp(sprintf('\t%s','Attribute-names:'));
        for n = 1:length(blockdata(k).attr_names);
            disp(sprintf('\t\t%s',blockdata(k).attr_names{n}));
        end
    end
    return;
elseif nargin>1 & mod(nargin,2)==0   %set(cIN,'Prop1',val,'Prop2',val2,...)
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
attrnames = cellstr(prop_vals{5});
Z0 = prop_vals{6};
sptype = prop_vals{7};

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
if isempty(sp_ix)
    for k = 1:length(bdata.dep_names)
        if length(size(bdata.dep_data{1}{k})) == 3 % This is probably the S-parameter data.
            sp_ix = k;            
        end
    end
end

freq_ix = find(ismember(bdata.dep_names,freqname));
if isempty(freq_ix)
    fnames = {'freq','Freq','frequency','FREQ','SWEEP.freq','SWEEP.Freq','SWPEEP.FREQ'};
    freq_guess = find(ismember(fnames,bdata.dep_names));
    if isempty(freq_guess), 
        error('Please specify the frequency name');
    else
        freqname = fnames{freq_guess};
        freq_ix = find(ismember(bdata.dep_names,freqname));
    end
end

sp_ix = find(ismember(bdata.dep_names,spname));
if isempty(sp_ix)
    spnames = {'S','s','S.m','S.s','OUT.S.m','OUT.S.s'};
    sp_guess = min(find(ismember(spnames,bdata.dep_names)));
    if isempty(sp_guess), 
        error('Please specify the S-parameter data name');
    else
        spname = spnames{sp_guess};
        sp_ix = find(ismember(bdata.dep_names,spname));
    end
end

if isempty(depnames)
    depnames = bdata.dep_names;
    dep_ix = 1:length(depnames);
    depnames([freq_ix,sp_ix]) = [];
    dep_ix([freq_ix,sp_ix]) = [];
else
    for k = 1:length(depnames)
        dix = find(ismember(bdata.dep_names,depnames{k}));
        if isempty(dix), 
            error('Illegal dependent parameter name');
        else
            dep_ix(k) = dix;
        end
    end
end

if isempty(attrnames)
    attrnames = bdata.attr_names;
    attr_ix = 1:length(attrnames);
else
    for k = 1:length(attrnames)
        aix = find(ismember(bdata.attr_names,attrnames{k}));
        if isempty(dix), 
            error('Illegal dependent parameter name');
        else
            attr_ix(k) = aix;
        end
    end
end

if isempty(freq_ix),error('Frequency must be defined');end

for n_meas = 1:size(bdata.var_values,2)
    tmp_state = measstate;
    tmp_msp = meassp;
    if ~isempty(sp_ix) % S-parameter data
        tmp_xp = xparam(bdata.dep_data{n_meas}{sp_ix},sptype,Z0,bdata.dep_data{n_meas}{freq_ix});
        tmp_msp = set(tmp_msp,'Data',tmp_xp);
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
    for k = 1:length(attr_ix) % General dependent data
        name = attrnames{k};
        name = strrep(name,'.','_'); % Replace . with _ in variable names
        dataval = bdata.attr_values{attr_ix(k),n_meas};
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