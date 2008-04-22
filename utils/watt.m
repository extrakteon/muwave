function p_w = watt(p_dbm)
% POWER_IN_WATT = DBM(POWER_IN_DBM)

p_w = 10.^((p_dbm-30)/10);

