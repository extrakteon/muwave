function display(a)

% $Header$
% $Author: fager $
% $Date: 2005-04-27 23:34:34 +0200 (Wed, 27 Apr 2005) $
% $Revision: 257 $ 
% $Log$
% Revision 1.4  2005/04/27 21:34:34  fager
% Only displays the first element if there is any!
%
% Revision 1.3  2004/04/28 15:55:05  koffer
% Now displays the first element of an arraymatrix. Nice for debug purposes.
%
%

disp(sprintf('arraymatrix-object'));
disp(sprintf('\t dimension:\t %g x %g', a.nx, a.ny));
disp(sprintf('\t elements:\t %g', a.m));

if ~isempty(a)
    disp(sprintf('\nFirst matrix element:'));
    disp(a.mtrx(:,:,1));
end
