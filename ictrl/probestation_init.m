function h_station = probestation_init(station)

switch station
    case '12K'
        h_station = ddeinit('EDMAIN','CMI COmmands');
    case '10K'
        h_station = gpib('ni', 0, 28);
        fopen(h_station);
end
