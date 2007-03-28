function cOut=measstate(varargin)
% Constructor for measstate class.
% The class is used to handle a measurement state.

% $Header$
% $Author: kristoffer $
% $Date: 2003-06-17 14:17:51 +0200 (Tue, 17 Jun 2003) $
% $Revision: 2 $ 
% $Log$
% Revision 1.1  2003/06/17 12:17:52  kristoffer
% Initial revision
%
% Revision 1.5  2002/03/29 12:49:39  kristoffer
% Fixed a minor error in the argument checking code
%
% Revision 1.4  2002/03/12 11:41:53  fager
% Changed to use arbitrary measurement state properties
%

switch nargin
case 0,     % Use default values
    data.Props = {};
    data.Values = {};
    cOut=class(data,'measstate');
case 1,
    if isa(varargin{1},'measstate')
        cOut=varargin{1};
    else
        error('Wrong input argument')
    end
end
