function [chksum]=adler32(str)
% ADLER32 Calculates the Adler-32 checksum of strings
% inputs:
%   str - string
% outputs:
%   chksum - checksum
%
% $Header$
% $Author: SYSTEM $
% $Date: 2004-09-28 21:06:59 +0200 (Tue, 28 Sep 2004) $
% $Revision: 213 $ 
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
