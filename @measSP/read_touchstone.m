function cOUT=read_touchstone(cIN,fname,nports)
% Function to create measSP object from Touchstone file.
% Usage:
% cOUT=read_touchstone(cIN,file_name,[nports])

% Version 1.0
% Created 02-01-03 by Christian Fager
%
% Revision history.
% v1.0 -- Date 02-01-04
% Created.

cSP=measSP(cIN);

% allow cell strings as input
if iscellstr(fname)
    fname = char(fname);
end

if nargin<3
	nports = [];
end

if ischar(fname)
    
    Y=read_touchstone_file(fname,nports);
    
    if isempty(Y.Date)
        Y.Date=datestr(now); 
    end
    
    % Assign the properties of the parent measmnt object
    cSP.measmnt=set(cSP.measmnt,'Origin',fname,'Date',Y.Date,'Operator',Y.Operator,'Info',Y.Info,...
        'GateWidth',Y.gate_width,'GateLength',Y.gate_length); 
    
    % And the measurement state object
    cSP.State=set(cSP.State,'Freq',Y.freq_list,'Vgsq',Y.Vgs,'Igsq',Y.Igs,'Vdsq',Y.Vds,'Idsq',Y.Ids,...
        'Temp',Y.Temp,'PulseWidth',Y.PulseWidth,'Period',Y.Period);

    % Assign the data property, xparam object
    XP=xparam;
    cSP.Data=buildxp(XP,Y.data,Y.Datatype,Y.Ref);
    cOUT=cSP;
else
    error('Wrong input arguments');
end
