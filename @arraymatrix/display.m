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
disp(sprintf('\t dimension:\t %g x %g', a.nx, a.ny));
disp(sprintf('\t elements:\t %g', a.m));