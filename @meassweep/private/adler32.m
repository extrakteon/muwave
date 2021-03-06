function [chksum]=adler32(str)
% ADLER32 Calculates the Adler-32 checksum of strings
% inputs:
%   str - string
% outputs:
%   chksum - checksum
%
% $Header$
% $Author: e7koffe $
% $Date: 2009-01-13 11:05:46 +0100 (ti, 13 jan 2009) $
% $Revision: 96 $ 
% $Log$
% Revision 1.1  2004/09/28 19:06:46  SYSTEM
% read_milousweep now has a caching function. Speeds up consecutive loads of identical-data!
%
%

N = length(str);
n = N:-1:1;
A = mod(1 + sum(str),65521);
B =mod(str*n' + N,65521);
Astr = sprintf('%04X',A);
Bstr = sprintf('%04X',B);
chksum = strcat(Bstr,Astr);
