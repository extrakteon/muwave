function p_dbm = dbm(p_w)
% POWER_IN_DBM = DBM(POWER_IN_WATT)

p_dbm = 10*log10(p_w) + 30;

