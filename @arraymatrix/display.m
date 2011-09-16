function display(a)
% DISPLAY Displays the dimensions and the first element of an arraymatrix (if there is one)

disp(sprintf('arraymatrix-object'));
disp(sprintf('\t dimension:\t %g x %g', a.nx, a.ny));
disp(sprintf('\t elements:\t %g', a.m));

if ~isempty(a)
    disp(sprintf('\nFirst matrix element:'));
    disp(a.mtrx(:,:,1));
end
