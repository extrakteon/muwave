function x_abs = read_chuck(h_station)
% read chuck position from probestation
switch class(h_station)
    case 'gpib'
        fprintf(h_station, ':move:abs?');
        x_abs = fscanf(h_station, '%f %f');
    otherwise
        str = ddereq(h_station,':mov:abs? 2',[1 1]);
        x_abs = sscanf(str, '%f %f %f');
end
