%
% ArrayMatrix
% class for handling arrays of matrices
%
% author: Kristoffer Andersson
%
%
% Method display
function display(a)

disp(sprintf('arraymatrix-object'));
disp(sprintf(strcat('\t dimension:\t',num2str(a.n))));
disp(sprintf(strcat('\t elements:\t',num2str(a.m))));