function cOUT=read_milousweep(cIN,FilePath,varargin)
%READ_MILOUSWEEP    Read multiple Touchstone files to a meassweep object.
%   M = read_milousweep(meassweep,'filepath','fileprefix','filesuffix')
%   scans the directory 'filepath' for Touchstone-files with prefix 'fileprefix' and
%   suffix 'filesuffix' and creates a corresponding meassweep object.
%
%   Example:
%   M = read_milousweep(meassweep,'test\d0509_all','A','');
%   will read all S-parameter files named A0, A1, ... etc. in the "test\d0509_all"
%   directory into the meassweep object M. 
%
%   M = read_milousweep(meassweep,'filepath','filelist')
%   reads the Touchstone-files given in filelist into a meassweep object.

% $Header$
% $Author$
% $Date$
% $Revision$ 
% $Log$


% Revision 1.10  2005/04/27 21:43:00  fager
% * Changed from measSP to meassp.
%
% Revision 1.9  2004/11/22 16:05:03  fager
% Replaced '\' by filesep to allow Linux compability..?!
%
% Revision 1.8  2004/10/19 14:34:52  koffer
% Caching now detetcts changes in file creation date and file sizes.
%
% Revision 1.7  2004/10/04 17:41:52  fager
% Places the cache files in the system defined "temp"-directory instead of current working directory.
%
% Revision 1.6  2004/09/28 19:06:59  SYSTEM
% read_milousweep now has a caching function. Speeds up consecutive loads of identical-data!
%
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
        Files = [];
        if iscell(varargin{1})
            Files = varargin{1};
        else
            Files{1} = varargin{1};
        end
        if FilePath(end) ~= filesep, FilePath=[FilePath,filesep]; end
        
    end
    % get list of files
    for i = 1:length(Files)
        File = Files{i};
        if File(end) == '.'
            File = File(1:end-1);
        end

        file_num_list(i) = i;
        file_name_list{i} = File;
        
        % make sure that the cache works
        dir_tmp = dir(fullfile(FilePath,File));
        file_date_list{i} = dir_tmp.date;
        file_bytes_list{i} = dir_tmp.bytes;
        
        origin = strcat(FilePath,File);
    end
    if isempty(file_name_list)
        error('Invalid path or prefix');
    end 
    
else
    FilePrefix = varargin{1};
    FileSuffix = varargin{2};
    % get list of files
    if FilePath(end) ~= filesep, FilePath=[FilePath,filesep]; end
    dir_list = dir(strcat(FilePath,FilePrefix,'*',FileSuffix));
    if isempty(dir_list)
        error('Invalid path or prefix');
    end
    %unsorted_file_list = zeros(1,length(dir_list));
    for k=1:length(dir_list)
        % extract the file number and sort it into a file_list
        name = dir_list(k).name;
        date = dir_list(k).date;
        bytes = dir_list(k).bytes;
        suffix_match = findstr(name,FileSuffix);
        if isempty(suffix_match)
            file_num = str2num(name(1+length(FilePrefix):end));
        else
            file_num = str2num(name(1+length(FilePrefix):suffix_match-1));
        end
        file_num_list(k) = file_num;
        file_name_list{k} = name;
        file_date_list{k} = date;
        file_bytes_list{k} = bytes;
    end
    origin = strcat(FilePath,FilePrefix,'*',FileSuffix);
end
cOUT = cIN;

[y,sort_index] = sort(file_num_list);

% calculate cache-file checksum
long_name = '';
for k=1:length(sort_index)
    file_name = fullfile(FilePath, file_name_list{sort_index(k)});
    file_date = file_date_list{sort_index(k)};
    file_bytes = num2str(file_bytes_list{sort_index(k)});
    long_name = strcat(long_name, file_name, file_date, file_bytes);    
end

% Create the cache file in the temp-directory as given in the apropriate registry entry.
cachefile = fullfile(tempdir,strcat('cache',adler32(long_name),'.mat'));

try
    % does a cachefile exist?
    tmp = load(cachefile);
    cOUT = tmp.cOUT;
catch
    % otherwise read each-file and create one!
    for k=1:length(sort_index)
        file_name = strcat(FilePath, file_name_list{sort_index(k)});
        cOUT = add(cOUT,read_touchstone(meassp,file_name));
    end
    cOUT=set(cOUT,'Date',datestr(now),'Origin',origin);    
    save(cachefile,'cOUT');
end


