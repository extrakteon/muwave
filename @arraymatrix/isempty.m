function c = isempty(a)
% ISEMPTY   Checks wheter the arraymatrix object is empty or not.

c = isempty(a.mtrx) | a.m == 0;