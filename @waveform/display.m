function display(a)
%WAVEFORM 
%   
% $Header$
% $Author: koffe $
% $Date: 2009-01-13 11:05:46 +0100 (ti, 13 jan 2009) $
% $Revision: 96 $ 
% $Log$
%


disp(sprintf('waveform-object'));
disp(sprintf(strcat('\t type:\t',num2str(get(a,'type')))));
disp(sprintf(strcat('\t reference:\t',num2str(get(a,'reference')))));
%disp(sprintf(strcat('\t fundamentals:\t',num2str(get(a,'fundamental')))));
disp(sprintf('\t ports:\t%d',get(a,'ports')));
disp(sprintf(strcat('\t frequencies:\t',num2str(get(a,'elements')))));
