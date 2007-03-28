function ft = ft(a)
% Return the ft of a two port
% 2002-01-09, Kristoffer Andersson
%             First version
ft = interp1(abs(h21(a)),freq(a),1,'spline','extrap');