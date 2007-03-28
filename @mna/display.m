
function display(x)

% display the unpopulated Y-matrix
disp('Admittance matrix:');
disp(x.Y);
disp('Parameters:');
disp(x.params');
disp('Parameter types:');
disp(x.param_type');
disp('Frequencies');
disp(x.f');
disp('Partials');
disp(x.partials');
