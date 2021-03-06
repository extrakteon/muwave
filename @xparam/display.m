%
% XPARAM
% 
% Class for handling S,Z,Y and T-parameters
%
% CHANGES:
% 2002-01-04, Kristoffer Andersson
%             Major rewrite version
%
function display(a)

disp(sprintf('xparam-object'));
disp(sprintf(strcat('\t type:\t',num2str(get(a,'type')))));
disp(sprintf(strcat('\t reference:\t',num2str(get(a,'reference')))));
disp(sprintf(strcat('\t ports:\t',num2str(get(a,'ports')))));
disp(sprintf(strcat('\t elements:\t',num2str(get(a,'elements')))));
if ~isempty(get(a,'freq')),
    disp(sprintf('\t freq:\t%G -> %G',min(get(a,'freq')),max(get(a,'freq'))));
end
if ~isempty(get(a,'datacov')),
    disp(sprintf(strcat('\t Covariance available')));
end