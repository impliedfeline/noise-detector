function s = squaredErrorsOfWalkForward(actual, estimate)
    order = numel(actual) - numel(estimate);
    window = actual(order + 1:numel(actual));
    errors = (window - estimate).^2;
    errors = [errors (order+1:numel(actual)).'];
    s = errors;
end