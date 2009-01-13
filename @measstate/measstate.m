function cOut=measstate(varargin)
%MEASSTATE  Constructor for the measstate class.
%   The measstate class stores information about a 
%   measurement state, such as bias, temperature etc.
%   It provides a basis for the meassp, measnoise child-classes

% $Header$
% $Author$
% $Date$
% $Revision$ 
% $Log$
% Revision 1.3  2005/04/27 21:40:38  fager
% * Changed from measSP to meassp.
%
% Revision 1.2  2003/07/16 09:59:40  fager
% Matlab help added.
%
% Revision 1.1.1.1  2003/06/17 12:17:52  kristoffer
%
%
% Revision 1.5  2002/03/29 12:49:39  kristoffer
% Fixed a minor error in the argument checking code
%
% Revision 1.4  2002/03/12 11:41:53  fager
% Changed to use arbitrary measurement state properties
%

switch nargin
case 0,     % Use default values
    data.props = {};
    data.values = {};
    cOut=class(data,'measstate');
case 1,
    if isa(varargin{1},'measstate')
        cOut=varargin{1};
    else
        error('Wrong input argument')
    end
end
