function x = remove_outlier(y)
x = y;
outliers = y - mean(y(:)) > 3*std(y(:));
x(outliers) = max(max(x(~outliers)));