function rc = chuck_up(h_station)
% $Rev$
% $Date$

% Raise chuck
switch class(h_station)
    case 'gpib'
        fprintf(h_station, ':move:cont');
        rc = 1;
    otherwise
        rc = ddeexec(h_station, ':mov:cont 2');
end


