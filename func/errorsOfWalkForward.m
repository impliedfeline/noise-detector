function s = errorsOfWalkForward(actual, estimate)
    order = numel(actual) - numel(estimate);
    window = actual(order + 1:numel(actual));
    errors = abs(window - estimate);
    errors = [errors (order+1:numel(actual)).'];
    s = errors;
end
