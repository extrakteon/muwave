function ParamPlot(varargin)
%PARAMPLOT Method to plot one or two S-parameter parameters
%   PARAMPLOT(MSP1,MSP2,'S11','smith',HAXES) plots S11 of the two meassp objects MSP1 and MSP2
%   in a Smith diagram. The plots appear in the plot defined by an axis handle HAXES. 
%   PARAMPLOT(MSP1,'Y11','logmag',HAXES) produces a logmag plot of MSP1's Y11. 
%   Allowed plot types are: 'smith', 'polar', 'logmag', 'mag', 'phase', 're', and 'im'.
%
%   See also: SMITHPLOT

%   (c) Kristoffer Andersson & Christian Fager, Chalmers University of Technology, Sweden

% $Header$
% $Author: koffe $
% $Date: 2009-01-13 11:05:46 +0100 (ti, 13 jan 2009) $
% $Revision: 96 $ 
% $Log$
% Revision 1.3  2005/04/27 21:41:32  fager
% * Changed from measSP to meassp.
%
% Revision 1.2  2004/10/20 22:24:29  fager
% Help comments added
%

nin=nargin;
if isa(varargin{nin},'double')
    haxes = varargin{nin};
    param = varargin{nin-2};
    type = varargin{nin-1};
    nargs = 3; 
else
    haxes = gca;
    param = varargin{nin-1};
    type = varargin{nin};
    nargs = 2;
end
 
Xin=varargin;
Xvect=[];
fvect=[];
for k=1:(nin - nargs)
    if ~isa(Xin{k},'meassp')
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
