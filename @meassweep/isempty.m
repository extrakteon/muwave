function out=isempty(cIN)
%ISEMPTY Returns 1 if the sweep object is empty.
%   OUT = ISEMPTY(MSWP) returns 1 if MSWP is empty.
%
%   See also: LENGTH

%   (c) Kristoffer Andersson & Christian Fager, Chalmers University of
%   Technology, Sweden

out = isempty(cIN.data);