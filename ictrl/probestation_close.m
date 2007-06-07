function rc = probestation_close(h_station)
% Close communication with probestation
switch class(h_station)
    case 'gpib'
        fclose(h_station);
        delete(h_station);
    otherwise
        rc = ddeterm(h_station);
end

