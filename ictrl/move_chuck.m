function rc = move_chuck(h_station,x_relative,x_reference,contact)
% Move chuck to specified position

% calculate absolute coordinates
abs_x = x_relative(1) + x_reference(1);
abs_y = x_relative(2) + x_reference(2);

% lower chuck
rc = chuck_down(h_station);

% move chuck
switch class(h_station)
    case 'gpib'
        cmd_str = sprintf(':move:abs %d %d;',abs_x,abs_y);
        fprintf(h_station, cmd_str);
        rc = 1;
    otherwise
        rc = ddeexec(h_station, sprintf(':mov:abs 2 %f %f none',abs_x,abs_y));
        if rc == 0
            return;
        end
end

% wait for chuck movement
pause(0.1);

% raise chuck if contact == 1
if contact == 1
    rc = chuck_up(h_station);
else
    rc = chuck_down(h_station);
end

% wait for chuck to settle
pause(0.1);
