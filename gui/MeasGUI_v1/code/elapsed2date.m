function [day, hour, min, sec] = elapsed2date(elapsed)

% Returns time left in days, hours, min and sec

sec = rem(elapsed, 60);
t_min = (elapsed-sec)/60;
min = rem(t_min, 60);
t_hour = (t_min-min)/60;
hour = rem(t_hour, 24);
day = (t_hour - hour) / 24;
