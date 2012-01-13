function [freq_list] = lsna_freq_list 

% Get Number of Frequency Points
mlen=0;
[hlsna,mlen]=calllib('lsnaapi','LSNAgetFreqListLength',mlen);

% Allocate Storage
freq_list = zeros(1,mlen);

% Read Frequency List
[hlsna,freq_list]=calllib('lsnaapi','LSNAgetFreqList',freq_list);
