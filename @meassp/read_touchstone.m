function cOUT=read_touchstone(cIN,fname,nports)
% READ_TOUCHSTONE Create meassp object from Touchstone file.
%   MSP = READ_TOUCHSTONE(MEASSP,'filename.S2P') reads the two-port
%   S-parameter measurement in the Touchstone file 'filename.S2P' into the
%   MEASSP object MSP.
%
%   MSP = READ_TOUCHSTONE(MEASSP,'filename',N) reads N-port
%   Touchstone file data.
%
%   See also: WRITE_TOUCHSTONE

%   (c) Kristoffer Andersson & Christian Fager, Chalmers University of Technology, Sweden

% $Header$
% $Author: fager $
% $Date: 2005-04-27 23:44:23 +0200 (Wed, 27 Apr 2005) $
% $Revision: 260 $ 
% $Log$
% Revision 1.9  2005/04/27 21:44:23  fager
% * Frequencies -> xparam
%
% Revision 1.8  2004/10/20 22:24:36  fager
% Help comments added
%
% Revision 1.7  2003/07/23 09:18:12  kristoffer
% Filename now added to origin-field
%
% Revision 1.6  2003/07/18 07:53:33  fager
% Now returns the frequency vector properly.
%
% Revision 1.5  2003/07/17 13:49:06  fager
% Allows custom properties, included in the file header, to be added to the meassp object.
%
% Revision 1.4  2003/07/17 08:54:26  fager
% freq replaced by Freq...
%
% Revision 1.3  2003/07/16 15:17:42  fager
% Frequency list now arranged as a row-vector.
%
% Revision 1.2  2003/07/16 14:47:26  fager
% Uses new measstate and measmnt addprop methods.
%

cSP=meassp(cIN);

% allow cell strings as input
if iscellstr(fname)
    fname = char(fname);
end

if nargin<3
    nports = [];
end

if ~ischar(fname), error('Wrong input arguments');end

Y = read_touchstone_file(fname,nports);

for k=1:length(Y.props)
    if ismember(Y.props{k},{'Origin','Date','Operator','Info','Transistor','Batch'})
        if strcmpi(Y.props{k},'Date') & isempty(Y.values{k})
            Y.values{k} = datestr(now)
        end
        cSP.measmnt=addprop(cSP.measmnt,Y.props{k},Y.values{k});  
    else
        cSP.measstate=addprop(cSP.measstate,Y.props{k},Y.values{k});  
    end
end
% filename
cSP.measmnt=addprop(cSP.measmnt,'Origin',fname);

% Assign the data property, xparam object
XP=xparam;
cSP.data=buildxp(XP,Y.data,Y.datatype,Y.ref,Y.freq_list);
cOUT=cSP;
