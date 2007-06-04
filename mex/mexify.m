function mexify(varargin)

if nargin == 0
    platform = '';
else
    platform = varargin{1};
end

path_lapack = 'C:/Program Files/MATLAB/R2006b/extern/lib/win32/microsoft/libmwlapack.lib';
%path_lapack = 'C:/Program Files/MATLAB/R2006b/extern/lib/win32/lcc/libmwlapack.lib';        

parts = {'aminv','ammul','amplus','amminus'};

switch platform
    case 'WIN'
        for k = 1:length(parts)
            cmd = sprintf('mex %s.c fort.c arraymatrix.c ''%s''',parts{k},path_lapack);
            eval(cmd);
        end
        %mex aminv.c fort.c arraymatrix.c 
        %mex ammul.c fort.c arraymatrix.c 'C:/Program Files/MATLAB71/extern/lib/win32/lcc/libmwlapack.lib'
        %mex amplus.c fort.c arraymatrix.c 'C:/Program Files/MATLAB71/extern/lib/win32/lcc/libmwlapack.lib'
        %mex amminus.c fort.c arraymatrix.c 'C:/Program Files/MATLAB71/extern/lib/win32/lcc/libmwlapack.lib'
    case 'WINDLL'
        for k = 1:length(parts)
            cmd = sprintf('mex -output %s.dll %s.c fort.c arraymatrix.c ''%s''',parts{k},parts{k},path_lapack);
            eval(cmd);
        end
        %mex -output aminv.dll aminv.c fort.c arraymatrix.c 'C:/Program Files/MATLAB71/extern/lib/win32/lcc/libmwlapack.lib'
        %mex -output ammul.dll ammul.c fort.c arraymatrix.c 'C:/Program Files/MATLAB71/extern/lib/win32/lcc/libmwlapack.lib'
        %mex -output amplus.dll amplus.c fort.c arraymatrix.c 'C:/Program Files/MATLAB71/extern/lib/win32/lcc/libmwlapack.lib'
        %mex -output amminus.dll amminus.c fort.c arraymatrix.c 'C:/Program Files/MATLAB71/extern/lib/win32/lcc/libmwlapack.lib'
    otherwise
        for k = 1:length(parts)
            cmd = sprintf('mex %s.c fort.c arraymatrix.c',parts{k});
            eval(cmd);
        end
        %mex aminv.c fort.c arraymatrix.c
        %mex ammul.c fort.c arraymatrix.c
        %mex amplus.c fort.c arraymatrix.c
        %mex amminus.c fort.c arraymatrix.c
end