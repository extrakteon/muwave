function display(a)

% $Header$
% $Author: koffer $
% $Date: 2004-04-28 17:55:05 +0200 (Wed, 28 Apr 2004) $
% $Revision: 188 $ 
% $Log$
% Revision 1.3  2004/04/28 15:55:05  koffer
% Now displays the first element of an arraymatrix. Nice for debug purposes.
%
%

disp(sprintf('arraymatrix-object'));
disp(sprintf('\t dimension:\t %g x %g', a.nx, a.ny));
disp(sprintf('\t elements:\t %g', a.m));

disp(sprintf('\nFirst matrix element:'));
disp(a.mtrx(:,:,1));
