function [block_names,block_data] = read_mdif_file(fname)
%READ_MDIF_FILE    Private function to parse MDIF files.

% $Header$
% $Author: fager $
% $Date: 2005-05-12 23:50:38 +0200 (Thu, 12 May 2005) $
% $Revision: 286 $
% $Log$
% Revision 1.7  2005/05/12 21:50:38  fager
% Now works also without any Attributes given.
%
% Revision 1.6  2005/05/12 14:58:20  fager
% Makes use of attributes
%
% Revision 1.5  2005/04/27 21:45:35  fager
% * Changed from measSP to meassp.
% * Compability with Matlab v7
%
% Revision 1.4  2005/03/22 15:51:41  fager
% Parameters now in the correct order.
%
% Revision 1.3  2005/03/22 13:35:16  fager
% 1. Accepts lines starting with %, directly followed by data format definition
% 2. Allows non-capital "Var"
% 3. Rewritten handling of scale factors
%
% Revision 1.2  2005/03/22 10:56:50  fager
% 1. Accepts blocks without preceding variables
% 2. Accepts vector formatted block data
%
% Revision 1.1  2005/03/22 00:36:37  fager
% First version
%

fid = fopen(fname,'r');
if fid == -1
    error('File not found.');
end


% Initialization of internal variable names
comments = {};
comment_count = 0;
block_names = {};
block_data = {};
block_count = [];
current_line = 0;
current_block = 0;
current_var_names = {};
current_var_values = [];
current_var_types = {};
current_attr_names = {};
current_attr_values = {};
current_attr_types = {};
into_descr_block = false;
scalechars = {'F','P','N','U','M','K','G','T'};
scales = [1e-15 1e-12 1e-9 1e-6 1e-3 1e3 1e9 1e12];

tline = fgetl(fid);
stop = feof(fid);  % Exit if an empty file

while ~stop
    current_line = current_line + 1;
    [s,f,linetokens]=regexp(tline,'(\S+)'); % Extract the line components
    if ~isempty(linetokens)
        keyw = tline(linetokens{1}(1):linetokens{1}(2));
        if strncmp(keyw,'%',1) & length(keyw)>1       % Special fix to take care of cases when line starts with % is immediately followed by definitions.
            keyw = '%';
            linetokens = {[1,1],linetokens{:}};
            linetokens{2}(1) = 2;
        end

        switch upper(keyw)
            case {'!','REM'}    % Comment lines
                comment_count = comment_count + 1;
                comments{comment_count} = tline((f(1)+1):end);
            case {'DSCR'}   % Descriptor field
                disp('DSCR');
            case {'VAR'}    % Variable name
                [s,f,linetokens]=regexp(tline,'(.+)\s+(.+)[=](.+)');
                name = tline(linetokens{1}(2,1):linetokens{1}(2,2));
                value = tline(linetokens{1}(3,1):linetokens{1}(3,2));
                if (isempty(name)|isempty(value)), error('Illegal VAR statement at line %d',current_line); end
                [s,f,to]=regexp(name,'(\S+)\((\w+)\)');
                if isempty(to), error('Illegal VAR statement at line %d',current_line); end
                var_name = name(to{1}(1,1):to{1}(1,2));
                var_type = name(to{1}(2,1):to{1}(2,2));
                if isempty(var_name), error('Illegal VAR name at line %d',current_line);end
                current_var_names = cat(1,current_var_names,cellstr(var_name));
                switch char(upper(var_type))
                    case {'0','INT'}
                        current_var_types = {current_var_types{:},'INT'};
                        [s,f,tint] = regexp(value,'(\d|\.)+(\w)');
                        tempval = round(str2double(value(tint{1}(1,1):tint{1}(1,2))));
                        if size(tint{1},1)==2,
                            scalechar = upper(value(tint{1}(2,1):tint{1}(2,2)));
                            if ~ismember(scalechar,scalechars), error('Illegal scale factor at line %d',current_line); end
                            tempval = tempval*scales(find(ismember(scalechars,scalechar(1))));
                        end
                        current_var_values = cat(2,current_var_values,tempval);
                        %current_var_values = {current_var_values{:},tempval}; % When string type should work...
                    case {'1','REAL'}
                        current_var_types = {current_var_types{:},'REAL'};
                        scale_ix = find(ismember(scalechars,value(end)));
                        if isempty(scale_ix),
                            tempval = str2double(value);
                        else
                            tempval = str2double(value(1:end-1))*scales(scale_ix);
                        end

                        current_var_values = cat(2,current_var_values,tempval);
                        %current_var_values = {current_var_values{:},tempval}; % When string type should work...
                    case {'2','STRING'}
                        warning('At line: %d; String type variables not supported',current_line);
                        % current_var_types = {current_var_types{:},'STRING'};
                        % value(find(value=='"'))=[];
                        % current_var_values = {current_var_values{:},value};
                    otherwise
                        error('Illegal VAR type at line %d',current_line);
                end
            case {'BEGIN'}  % Block definition
                current_blockname = tline(linetokens{2}(1):linetokens{2}(2));
                if strncmp(current_blockname,'DSCR',4), % Is this a description block?
                    into_descr_block = true;
                else
                    current_block = find(ismember(block_names,current_blockname));
                    if isempty(current_block) % This must be a new block appearing
                        block_names = {block_names{:},current_blockname};
                        current_block = length(block_names);
                        block_count(current_block) = 1;
                    else
                        block_count(current_block) = block_count(current_block) + 1;
                    end
                end
            case {'#'}  % Read attribute data
                [s,f,linetokens]=regexp(tline,'(.+)\s+(.+)[=](.+)');
                name = tline(linetokens{1}(2,1):linetokens{1}(2,2));
                value = tline(linetokens{1}(3,1):linetokens{1}(3,2));
                if (isempty(name)|isempty(value)), error('Illegal VAR statement at line %d',current_line); end
                [s,f,to]=regexp(name,'(\S+)\((\w+)\)');
                if isempty(to), error('Illegal VAR statement at line %d',current_line); end
                attr_name = name(to{1}(1,1):to{1}(1,2));
                attr_type = name(to{1}(2,1):to{1}(2,2));
                current_attr_names = cat(1,current_attr_names,cellstr(attr_name));
                switch upper(attr_type)
                    case {'0','INT'}
                        current_attr_types = cat(1,current_attr_types,{'NUMERIC'});
                        [s,f,tint] = regexp(value,'(\d|\.)+(\w)');
                        tempval = round(str2double(value(tint{1}(1,1):tint{1}(1,2))));
                    case {'1','REAL'}
                        current_attr_types = cat(1,current_attr_types,{'NUMERIC'});
                        scale_ix = find(ismember(scalechars,value(end)));
                        if isempty(scale_ix),
                            tempval = str2double(value);
                        else
                            tempval = str2double(value(1:end-1))*scales(scale_ix);
                        end
                        current_attr_values = {current_attr_values{:},tempval};
                    case {'2','STRING'}
                        current_attr_types = cat(1,current_attr_types,{'STRING'});
                        value = strrep(value,'"','');
                        current_attr_values = {current_attr_values{:},value};
                    case {'3','COMPLEX'}
                        current_attr_types = cat(1,current_attr_types,{'NUMERIC'});
                        tempval = str2double(value);
                        current_attr_values = {current_attr_values{:},tempval};
                    otherwise
                        error('Illegal attribute format at line %d',current_line);
                end
            case {'%'}  % Read formatted data
                % Parse data format line
                if ~into_descr_block
                    for k = 2:length(linetokens)
                        item_descr = tline(linetokens{k}(1):linetokens{k}(2));
                        [s,f,to]=regexp(item_descr,'(\S+)\((\w+)\)');
                        if isempty(to), error('Illegal data format at line %d',current_line); end
                        dep_types{k-1} = item_descr(to{1}(2,1):to{1}(2,2));
                        dep_names{k-1} = item_descr(to{1}(1,1):to{1}(1,2));
                    end

                    % Start reading data.
                    rawdata = fscanf(fid,'%f');
                    ncols = length(dep_types) + sum(ismember(lower(dep_types),'complex'));
                    current_line = current_line + round(length(rawdata)/ncols);
                    rawdata = reshape(rawdata,ncols,[]).';
                    rawcol = 0;
                    tmpdata = [];
                    matrix_index = {};
                    data = {};
                    for k = 1:length(dep_types)
                        rawcol = rawcol + 1;
                        if strcmpi(dep_types(k),'complex')
                            tmpdata(:,k) = rawdata(:,rawcol) + j*rawdata(:,rawcol+1);
                            rawcol = rawcol + 1; % Additional column
                        else
                            tmpdata(:,k) = rawdata(:,rawcol);
                        end
                        [s,f,to] = regexp(dep_names{k},'(\w|\.)+');
                        real_names{k} = dep_names{k}(to{1}(1):to{1}(2));
                        switch length(to)
                            case 3
                                matrix_index{k} = [str2double(dep_names{k}(to{2}(1):to{2}(2))),str2double(dep_names{k}(to{3}(1):to{3}(2)))];
                            case 2
                                matrix_index{k} = str2double(dep_names{k}(to{2}(1):to{2}(2)));
                            case 1
                                matrix_index{k} = [];
                            otherwise
                                error('Illegal dependent variable format at line %d',current_line);
                        end
                    end

                    % See if there are any matrix variables
                    % Confession: Very cumbersome implementation!
                    temp_names = real_names;
                    all_names_found = false;
                    name_count = 0;
                    unique_dep_names = {};
                    while ~all_names_found
                        name_count = name_count + 1;
                        curr_name = temp_names{1};
                        all_curr_ix = find(ismember(real_names,curr_name));
                        switch length(matrix_index{all_curr_ix(1)})
                            case 0, % Scalar value
                                data{name_count} = tmpdata(:,all_curr_ix);
                            case 1, % Vector values
                                for k = 1:length(all_curr_ix)
                                    data{name_count}(:,matrix_index{all_curr_ix(k)}(1)) = tmpdata(:,all_curr_ix(k));
                                end
                            case 2, % Matrix values
                                for k = 1:length(all_curr_ix)
                                    data{name_count}(matrix_index{all_curr_ix(k)}(1),matrix_index{all_curr_ix(k)}(2),:) = tmpdata(:,all_curr_ix(k));
                                end
                        end

                        temp_names(find(ismember(temp_names,curr_name))) = []; % Remove the found occurances of the name
                        unique_dep_names = {unique_dep_names{:},curr_name};
                        all_names_found = isempty(temp_names); % Have all names been found?
                    end

                    block_data(current_block).dep_data{block_count(current_block)} = data;
                    block_data(current_block).dep_names = unique_dep_names;
                end
            case {'END'}
                if into_descr_block
                    into_descr_block = false;
                else
                    if ~isempty(current_var_names)
                        block_data(current_block).var_names = current_var_names;
                        block_data(current_block).var_values(:,block_count(current_block)) = current_var_values';
                    end
                    if ~isempty(current_attr_names)
                        block_data(current_block).attr_names = current_attr_names;
                        block_data(current_block).attr_types = current_attr_types;
                        block_data(current_block).attr_values(:,block_count(current_block)) = current_attr_values';
                    else
                        block_data(current_block).attr_names = {};
                        block_data(current_block).attr_types = {};
                        block_data(current_block).attr_values= {};
                    end                        

                    current_var_names = {};
                    current_var_values = [];
                    current_var_types = {};
                    current_attr_names = {};
                    current_attr_types = {};
                    current_attr_values = {};

                    dep_types = {};
                    dep_names = {};
                    real_names = {};
                end
        end
    end
    stop = feof(fid);
    tline = fgetl(fid);
end
fclose(fid);