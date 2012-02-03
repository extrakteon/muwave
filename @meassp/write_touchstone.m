function write_touchstone(cIN,write_filename)
%WRITE_TOUCHSTONE   Writes a meassp object to Touchstone file.
%   WRITE_TOUCHSTONE(MSP1,'filename.S2P') writes the data in the meassp-object MSP1
%   into a Touchstone file 'filename.S2P'. 
%   Example:
%       write_touchstone(msp1,'filename.S2P')
%  
%   See also: READ_TOUCHSTONE

%   (c) Kristoffer Andersson & Christian Fager, Chalmers University of Technology, Sweden

% $Header$
% $Header: /milou/matlab_milou/@measSP/write_touchstone.m,v 1.5 2005/10/24 18:50:46 koffer Exp $
% $Author: koffe $
% $Date: 2009-01-13 11:05:46 +0100 (ti, 13 jan 2009) $
% $Revision: 96 $ 
% $Log$
% $Log: write_touchstone.m,v $
% Revision 1.5  2005/10/24 18:50:46  koffer
% Fixed malfunction caused by moving Freq to xparam.
%
% Revision 1.4  2005/04/27 21:41:32  fager
% * Changed from measSP to meassp.
%
% Revision 1.3  2004/10/20 22:25:11  fager
% Help comments added
%
% Revision 1.2  2003/07/18 09:03:13  fager
% Any meassp properties are now added to the file header. Works fine with read_touchstone.
%

ports=get(cIN.data,'ports');
extix=findstr('.',write_filename);
if isempty(extix)	% No extension specified, use S-parameter representation
    ext=['.S',int2str(ports),'P'];
    write_filename=[write_filename,ext];
end

f_ID=fopen(write_filename,'wt');
if f_ID==-1, error('Error in opening file for writing'); end;

% Get the measmnt and measstate property names.
m_state = get(cIN,'measstate');
m_state_names = get(m_state);
% remove Freq from m_state_names
m_state_names = setdiff(m_state_names,'Freq');
m_info = get(cIN,'measmnt');
m_info_names = get(m_info);

% Write the measmnt properties to the Touchstone file header
for k=1:length(m_info_names)
    TempStr =['! ',m_info_names{k},' : ',num2str(get(m_info,m_info_names{k}))];
    fprintf(f_ID,'%s\n',TempStr);
end
% Write the measstate properties to the Touchstone file header
for k=1:length(m_state_names)
    val = num2str(get(m_state, m_state_names{k}));
    if size(val,1)~=1, continue;end;
    TempStr = ['! ', m_state_names{k},' : ',val];
    fprintf(f_ID,'%s\n',TempStr);
end

% Add blank line
fprintf(f_ID,'\n');

data_mtrx=1e-9*get(cIN,'freq');
for col=1:ports
    for row=1:ports
        temp=get(cIN.data,['S',int2str(row),int2str(col)]);
        data_mtrx=cat(2,data_mtrx,[real(temp),imag(temp)]);
    end
end

% Write the data.
reference=get(cIN.data,'reference');
type=get(cIN.data,'type');	

TempStr=['# GHZ S RI R ',int2str(reference)];
fprintf(f_ID,'%s\n',TempStr);

scanstr=['%e',repmat([' %e %e'],[1,ports^2]),'\n'];
fprintf(f_ID,scanstr,data_mtrx.');

% Close the file.
fclose(f_ID);

