function out = max(varargin)
%MAX  returns the max element of each element
%
% $Header$
% $Author$
% $Date$
% $Revision$ 
% $Log$
%

if nargin == 1
    out = max(varargin{1}.data);
elseif nargin == 2
    a = xparam(varargin{1});
    b = xparam(varargin{2});
    % check so that the dimensions are equal
    if a==b
        out = a;
        out.data = max(a.data,b.data);
    end
else
    error('XPARAM.MAX: Wrng number of arguments.');
end    