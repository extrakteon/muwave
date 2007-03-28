function write_touchstone(cIN,write_filename)
%WRITE_TOUCHSTONE   Writes a measSP object to Touchstone file.
%   WRITE_TOUCHSTONE(MSP1,'filename.S2P') writes the data in the meassp-object MSP1
%   into a Touchstone file 'filename.S2P'. 
%   Example:
%       write_touchstone(msp1,'filename.S2P')
%  
%   See also: READ_TOUCHSTONE

%   (c) Kristoffer Andersson & Christian Fager, Chalmers University of Technology, Sweden

% $Header$
% $Author: fager $
% $Date: 2004-10-21 00:25:32 +0200 (Thu, 21 Oct 2004) $
% $Revision: 220 $ 
% $Log$
% Revision 1.3  2004/10/20 22:25:11  fager
% Help comments added
%
% Revision 1.2  2003/07/18 09:03:13  fager
% Any measSP properties are now added to the file header. Works fine with read_touchstone.
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
m_state=get(cIN,'measstate');
m_state_names=get(m_state);
m_info=get(cIN,'measmnt');
m_info_names=get(m_info);

% Write the measmnt properties to the Touchstone file header
for k=1:length(m_info_names)
    TempStr =['! ',m_info_names{k},' : ',num2str(get(m_info,m_info_names{k}))];
    fprintf(f_ID,'%s\n',TempStr);
end
% Write the measstate properties to the Touchstone file header
for k=1:length(m_state_names)
    val= num2str(get(m_state,m_state_names{k}));
    if size(val,1)~=1, continue;end;
    TempStr =['! ',m_state_names{k},' : ',val];
    fprintf(f_ID,'%s\n',TempStr);
end

% Add blank line
fprintf(f_ID,'\n');

data_mtrx=1e-9*freq(cIN);
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
fprintf(f_ID,'%s\n\n',TempStr);

scanstr=['%e',repmat([' %e %e'],[1,ports^2]),'\n'];
fprintf(f_ID,scanstr,data_mtrx.');

% Close the file.
fclose(f_ID);