function cOUT=read_milousweep_exp(cIN,FilePath,FilePrefix,FileSuffix)

INclass=meassweep(cIN);


% get list of files
if FilePath(end) ~= '\', FilePath=[FilePath,'\']; end
dir_list = dir(strcat(FilePath,FilePrefix,'*'));
if isempty(dir_list)
    error('Invalid path or prefix');
end

%unsorted_file_list = zeros(1,length(dir_list));
for k=1:length(dir_list)
    % extract the file number and sort it into a file_list
    name = dir_list(k).name;
    suffix_match = strmatch(name,FileSuffix);
    if isempty(suffix_match)
        file_num = str2num(name(1+length(FilePrefix):end));
    else
        file_num = str2num(name(1+length(FilePrefix):suffix_match-1));
    end
    file_num_list(k) = file_num;
    file_name_list{k} = name;
end
[y,sort_index] = sort(file_num_list);

for k=1:length(sort_index)
    file_name = strcat(FilePath, file_name_list{sort_index(k)});
    INclass.Data{k}=read_touchstone(measSP,file_name);
end

INclass=set(INclass,'Date','today','Origin',strcat(FilePath,FilePrefix,'*',FileSuffix),'GateWidth',getGateWidth(INclass.Data{end}),'GateLength',getGateLength(INclass.Data{end}),'DataType','SP');

cOUT=INclass; 
