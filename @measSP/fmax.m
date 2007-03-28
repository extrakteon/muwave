function fmax = fmax(a)
% Return the fmax of a two port
% 2002-01-09, Kristoffer Andersson
%             First version
fmax = interp1(gtumax(a),freq(a),1,'spline','extrap');