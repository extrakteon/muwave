function display(a)
%WAVEFORM 
%   
% $Header$
% $Author$
% $Date$
% $Revision$ 
% $Log$
%


disp(sprintf('waveform-object'));
disp(sprintf(strcat('\t type:\t',num2str(get(a,'type')))));
disp(sprintf(strcat('\t reference:\t',num2str(get(a,'reference')))));
%disp(sprintf(strcat('\t fundamentals:\t',num2str(get(a,'fundamental')))));
disp(sprintf('\t ports:\t%d',get(a,'ports')));
disp(sprintf(strcat('\t frequencies:\t',num2str(get(a,'elements')))));
