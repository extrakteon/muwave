function l = xparam(a,b,c,d,e)
%XPARAM Constructor for the xparam class.
%   The class xparam is used to handle single-bias S/Y/Z/T-parameter measurements.
%   The X-parameter contains information about the corresponding frequencies. 
%   If available, the xparam object can also contain information about the
%   measurement uncertainties. 
%
%
%   XP = XPARAM creates a default, empty xparam object.
%
%   XP = XPARAM(DATA); Creates an xparam object with X-param data in
%   an arraymatrix object DATA. The data is assumed to be 50 ohm S-parameters.
%
%   XP = XPARAM(DATA,TYPE); Specifies that the data is of 'S','T','Z',
%   or 'Y' type.
%
%   XP = XPARAM(DATA,TYPE,REFZ); Specifies the reference impedance to be REFZ ohm.
%
%   XP = XPARAM(DATA,TYPE,REFZ,FREQ); Specifies the frequencies to be FREQ.
%
%   XP = XPARAM(DATA,TYPE,REFZ,FREQ,DATACOV); Specifies the data uncertainty
%   by an X-parameter covariance matrix (arraymatrix-object). 
%   The covariance should be given with respect to absolute deviations: 
%   E{[Re(X11) Im(X11) Re(X21) Im(X21) ... Im(X22)]*[Re(X11) Im(X11) Re(X21)
%   Im(X21) ... Im(X22)]'};
%   
%   See also: @MEASSP (class), @MEASMNT (class), @MEASSTATE (class), GET, SET, DISPLAY

%   (c) Kristoffer Andersson & Christian Fager, Chalmers University of Technology, Sweden

% $Header$
% $Author$
% $Date$
% $Revision$ 
% $Log$
% Revision 1.2  2005/04/27 21:41:53  fager
% * Version logging added.
% * Frequencies -> xparam.
% * Possibility of including measurement covariances added
%

if nargin==0
    % S-parameters default & 50 Ohms system impedance
    p.type = 'S';
    p.reference = 50;
    p.data = arraymatrix;
    p.freq = []; 
    p.datacov = arraymatrix;
    
    l = class(p, 'xparam');
else
    if isa(a,'xparam')
        l = a;
    else
        a = arraymatrix(a);
        if nargin==1
            % xparam(data_mtrx)
            % Use type = Z as default!
            % Use reference = 50 as default!
            p.type = 'Z';
            p.reference = 50;
            p.data = a;
            p.freq = [];
            p.datacov = [];            
            l = class(p, 'xparam');
        elseif nargin==2  & isvalid_type(b)
            % xparam(arraymatrix, type)
            % Use reference = 50 as default!
            p.type = b;
            p.reference = 50;
            p.data = a;
            p.freq = [];
            p.datacov = [];            
            l = class(p, 'xparam');
        elseif nargin==3  & isvalid_type(b) & isa(c,'double')
            % xparam(arraymatrix, type, reference)
            p.type = b;
            p.reference = c;
            p.data = a;
            p.freq = [];
            p.datacov = [];
            l = class(p, 'xparam');
        elseif nargin==4  & isvalid_type(b) & isa(c,'double') & isa(d,'double')
            % xparam(arraymatrix, type, reference, freq)
            p.type = b;
            p.reference = c;
            p.data = a;
            p.freq = reshape(d,[],1);
            p.datacov = [];
            l = class(p, 'xparam');
        elseif nargin==5  & isvalid_type(b) & isa(c,'double') & isa(d,'double')
            % xparam(arraymatrix, type, reference, freq)
            p.type = b;
            p.reference = c;
            p.data = a;
            p.freq = reshape(d,[],1);
            p.datacov = arraymatrix(e);
            l = class(p, 'xparam');
        else
            error('XPARAM.XPARAM: Invalid input argument(s).')   
        end
    end
end

%
% Internal functions
%

