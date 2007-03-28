%
% XPARAM
% 
% Class for handling S,Z,Y and T-parameters
%
% CHANGES:
% 2002-01-03, Kristoffer Andersson
%             Major rewrite version
% 2002-01-05, Christian Fager
%             Changed the string comparison to using strcmp.
%
function valid=isvalid_type(str)
if ischar(str) & (sum(strcmp(str,{'S','Y','Z','T'})))
	valid = 1;
else
   valid = 0;
   error('XPARAM.XPARAM: Invalid type. Should be either of: S,Y,Z,T');
end
