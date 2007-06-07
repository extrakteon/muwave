function rc = chuck_down(h_station)
% Lower chuck
switch class(h_station)
    case 'gpib'
        fprintf(h_station, ':move:sep');
        rc = 1;
    otherwise
        rc = ddeexec(h_station, ':mov:sep 2');
end