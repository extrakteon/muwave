%
function mexify(varargin)

if nargin == 0
    platform = '';
else
    platform = varargin{1};
end


switch computer('arch')
    case {'glnx86','maci64','glnxa64'}
        path_lapack = '-lmwlapack -lmwblas';
    case 'win32'
        path_lapack = sprintf('%s/extern/lib/win32/%s/libmwlapack.lib %s/extern/lib/win32/%s/libmwblas.lib',matlabroot,'lcc',matlabroot,'lcc');
    case 'win64'
        path_lapack = sprintf('%s/extern/lib/win64/%s/libmwlapack.lib %s/extern/lib/win64/%s/libmwblas.lib','C:\PROGRA~1\MATLAB\R2009A\','microsoft','C:\PROGRA~1\MATLAB\R2009A\','microsoft');
end
        
switch computer('arch')
    case {'win32','glnx86'}
        %cmdstr = 'mex -f mexopts.sh %s.c fort.c arraymatrix.c %s';
        cmdstr = 'mex %s.c fort.c arraymatrix.c %s';
    case {'glnx86','maci64','glnxa64','win64'}
        %cmdstr = 'mex -f mexopts.sh %s.c fort.c arraymatrix.c -largeArrayDims %s';
        cmdstr = 'mex %s.c fort.c arraymatrix.c -largeArrayDims %s';
end

parts = {'ammul','amplus','amminus','aminv'};
for k = 1:length(parts)
    cmd = sprintf(cmdstr,parts{k},path_lapack);
    eval(cmd);
end

copyfile('*.mex*','../@arraymatrix/private/');
delete('*.mex*');