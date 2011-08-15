%
function mexify(varargin)

if nargin == 0
    platform = '';
else
    platform = varargin{1};
end


switch computer('arch')
    case {'glnx86','maci','glnxa64'}
        path_lapack = '-lmwlapack -lmwblas';
    case 'win32'
        path_lapack = sprintf('%s/extern/lib/win32/%s/libmwlapack.lib %s/extern/lib/win32/%s/libmwblas.lib',matlabroot,'lcc',matlabroot,'lcc');
    case 'win64'
        path_lapack = sprintf('%s/extern/lib/win64/%s/libmwlapack.lib %s/extern/lib/win64/%s/libmwblas.lib','C:\PROGRA~1\MATLAB\R2009A\','microsoft','C:\PROGRA~1\MATLAB\R2009A\','microsoft');
end
        
parts = {'ammul','amplus','amminus','aminv'};

for k = 1:length(parts)
    cmd = sprintf('mex -f mexopts.sh %s.c fort.c arraymatrix.c -largeArrayDims %s',parts{k},path_lapack);
    %cmd = sprintf('mex -f mexopts.sh %s.c fort.c arraymatrix.c %s',parts{k},path_lapack);
    eval(cmd);
end

copyfile('*.mex*','../@arraymatrix/private/');
