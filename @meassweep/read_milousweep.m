function cOUT=read_milousweep(cIN,FilePath,varargin)
%READ_MILOUSWEEP    Read multiple Touchstone files to a meassweep object.
%   M = read_milousweep(meassweep,'filepath','fileprefix','filesuffix')
%   scans the directory 'filepath' for Touchstone-files with prefix 'fileprefix' and
%   suffix 'filesuffix' and creates a corresponding meassweep object.
%
%   M = read_milousweep(meassweep,'filepath','filelist')
%   reads the Touchstone-files given in filelist into a meassweep object.

% $Header$
% $Author: kristoffer $
% $Date: 2003-08-18 09:49:46 +0200 (Mon, 18 Aug 2003) $
% $Revision: 120 $ 
% $Log$
% Revision 1.5  2003/08/18 07:46:26  kristoffer
% no message
%
% Revision 1.4  2003/07/24 10:07:17  kristoffer
% no message
%
% Revision 1.3  2003/07/24 10:05:57  kristoffer
% Added support for file-lists
%
% Revision 1.2  2003/07/21 08:32:22  fager
% Initial. Matlab help and CVS logging added.
%

if nargin < 4
    % given a file list
    if nargin == 2
        Files = FilePath;
        FilePath = '';
    else
        Files = varargin{1};    
        if FilePath(end) ~= '\', FilePath=[FilePath,'\']; end
    end
    % get list of files
    for i = 1:length(Files)
        File = Files{i};
        if File(end) == '.'
            File = File(1:end-1);
        end
        file_name_list{i} = File;
        file_num_list(i) = i;
        origin = strcat(FilePath,File);
    end
    if isempty(file_name_list)
        error('Invalid path or prefix');
    end 
    
else
    FilePrefix = varargin{1};
    FileSuffix = varargin{2};
    % get list of files
    if FilePath(end) ~= '\', FilePath=[FilePath,'\']; end
    dir_list = dir(strcat(FilePath,FilePrefix,'*',FileSuffix));
    if isempty(dir_list)
        error('Invalid path or prefix');
    end
    %unsorted_file_list = zeros(1,length(dir_list));
    for k=1:length(dir_list)
        % extract the file number and sort it into a file_list
        name = dir_list(k).name;
        suffix_match = findstr(name,FileSuffix);
        if isempty(suffix_match)
            file_num = str2num(name(1+length(FilePrefix):end));
        else
            file_num = str2num(name(1+length(FilePrefix):suffix_match-1));
        end
        file_num_list(k) = file_num;
        file_name_list{k} = name;
    end
    origin = strcat(FilePath,FilePrefix,'*',FileSuffix);
end
cOUT = cIN;

[y,sort_index] = sort(file_num_list);

for k=1:length(sort_index)
    file_name = strcat(FilePath, file_name_list{sort_index(k)});
    %cOUT.data{k}=read_touchstone(measSP,file_name);
    cOUT = add(cOUT,read_touchstone(measSP,file_name));
end

cOUT=set(cOUT,'Date',datestr(now),'Origin',origin);