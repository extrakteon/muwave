function mexify(varargin)

if nargin == 0
    platform = '';
else
    platform = varargin{1};
end

switch platform
    case 'WIN'
        mex aminv.c fort.c arraymatrix.c 'C:/Program Files/MATLAB71/extern/lib/win32/lcc/libmwlapack.lib'
        mex ammul.c fort.c arraymatrix.c 'C:/Program Files/MATLAB71/extern/lib/win32/lcc/libmwlapack.lib'
        mex amplus.c fort.c arraymatrix.c 'C:/Program Files/MATLAB71/extern/lib/win32/lcc/libmwlapack.lib'
        mex amminus.c fort.c arraymatrix.c 'C:/Program Files/MATLAB71/extern/lib/win32/lcc/libmwlapack.lib'
    case 'WINDLL'
        mex -output aminv.dll aminv.c fort.c arraymatrix.c 'C:/Program Files/MATLAB71/extern/lib/win32/lcc/libmwlapack.lib'
        mex -output ammul.dll ammul.c fort.c arraymatrix.c 'C:/Program Files/MATLAB71/extern/lib/win32/lcc/libmwlapack.lib'
        mex -output amplus.dll amplus.c fort.c arraymatrix.c 'C:/Program Files/MATLAB71/extern/lib/win32/lcc/libmwlapack.lib'
        mex -output amminus.dll amminus.c fort.c arraymatrix.c 'C:/Program Files/MATLAB71/extern/lib/win32/lcc/libmwlapack.lib'
    otherwise
        mex aminv.c fort.c arraymatrix.c
        mex ammul.c fort.c arraymatrix.c
        mex amplus.c fort.c arraymatrix.c
        mex amminus.c fort.c arraymatrix.c
end