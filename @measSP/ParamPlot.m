% $Header$
% $Author: kristoffer $
% $Date: 2003-06-17 14:17:51 +0200 (Tue, 17 Jun 2003) $
% $Revision: 2 $ 
% $Log$
% Revision 1.1  2003/06/17 12:17:52  kristoffer
% Initial revision
%
% Revision 1.2  2002/11/11 14:34:30  fager
% Multiple input parameters enabled
%
% Revision 1.1  2002/04/15 12:00:44  kristoffer
% no message
%
% 
function ParamPlot(varargin)
% Method to plot one or two params

% Typical calling syntax:
% ParamPlot(measSP1,measSP2,'S11','smiplot',haxes);
% ParamPlot(measSP1,'Y11','log',haxes);

nin=nargin;
haxes=varargin{nin};
param=varargin{nin-2};
type=varargin{nin-1};
Xin=varargin;
Xvect=[];
fvect=[];
for k=1:nin-3
    if ~isa(Xin{k},'measSP')
        error('Wrong input argument');
    end
    Xvect=cat(2,Xvect,get(Xin{k},param));
    fvect=cat(2,fvect,freq(Xin{k}));
end
axes(haxes);
switch upper(type)
case 'SMITH'
    smiplot(Xvect);
case 'POLAR'
    smipolar(Xvect);
case 'LOGMAG'
    logmagplot(Xvect,fvect*1e-9); % scale to GHz
case 'MAG'
    magplot(Xvect,fvect*1e-9);
case 'PHASE'
    phaseplot(Xvect,fvect*1e-9);
case 'RE'
    replot(Xvect,fvect*1e-9);
case 'IM'
    implot(Xvect,fvect*1e-9);
otherwise
    error('Unknown plot format.');
end
