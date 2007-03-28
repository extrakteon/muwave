function [SPobjOut,NoiseobjOut]=read_touchstone_noise(cIN,varargin)
% Converts a Touchstone formatted file from ATN5 noise measurement system into 
% the matrix format used by Milou.

% Version 1.0
% Created 02-01-10 by Christian Fager
%
% Revision history.
% v1.0 -- Date 02-01-10
% Created.

nin=nargin;

switch nin
case 2, % filename
    cN=cIN;
    cSP=meassp;  % Create empty measNoise object.
    fname=varargin{1};
    if ~isstr(fname)
        error('Second argument is supposed to be a file name');
    end
otherwise
    error('Wrong number of input arguments')
end
Y=read_touchstone_noise_file(fname);

if isempty(Y.Date)
    Y.Date=datestr(now); 
end

% Assign the properties of the parent measmnt object
cSP=set(cSP,'Origin',fname,'Date',Y.Date,'Operator',Y.Operator,'Info',Y.Info,...
    'GateWidth',Y.gate_width,'GateLength',Y.gate_length); 
cSP=set(cSP,'Freq',Y.freq_list,'Vgsq',Y.Vgs,'Igsq',Y.Igs,'Vdsq',Y.Vds,'Idsq',Y.Ids,...
    'Temp',Y.Temp,'PulseWidth',Y.PulseWidth,'Period',Y.Period);
cSP=set(cSP,'Data',buildxp(xparam,Y.data,Y.Datatype,Y.Ref));

% The noise object
cN=set(cN,'Origin',fname,'Date',Y.Date,'Operator',Y.Operator,'Info',Y.Info,...
    'GateWidth',Y.gate_width,'GateLength',Y.gate_length); 
% The state
cN=set(cN,'Freq',Y.freq_list_noise,'Vgsq',Y.Vgs,'Igsq',Y.Igs,'Vdsq',Y.Vds,'Idsq',Y.Ids,...
    'Temp',Y.Temp,'PulseWidth',Y.PulseWidth,'Period',Y.Period);
% The data
cN=set(cN,'Rn',Y.Rn,'NF',Y.NF,'GammaOpt',Y.Sopt,'Fmin',Y.Fmin);

SPobjOut=cSP;
NoiseobjOut=cN;