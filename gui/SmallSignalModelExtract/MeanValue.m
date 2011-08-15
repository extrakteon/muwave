function mean = MeanValue(X, from, to)
mean = sum(X(from:to)) / (to-from+1);
