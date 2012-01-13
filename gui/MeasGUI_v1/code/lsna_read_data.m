function [data] = lsna_read_data(parameter); 

% Get Number of Frequency Points
mlen=0;
[hlsna,mlen]=calllib('lsnaapi','LSNAgetFreqListLength',mlen);

variable=parameter(1);
port=str2double(parameter(2));

% Allocate Storage
re_data=zeros(1,mlen);
im_data=zeros(1,mlen);

% Read data
[hlsna,variable,re_data,im_data]=calllib('lsnaapi','LSNAgetFreqData',variable,port,re_data,im_data);
data = re_data+j*im_data;
