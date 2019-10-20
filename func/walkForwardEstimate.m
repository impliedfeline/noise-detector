function e = walkForwardEstimate(model, input)
    coefficients = flip(model.Report.Parameters.ParVector);
    order = numel(coefficients);
    len = numel(input) - order;
    estimates = zeros(len, 1);
    for i = 1:order
        j = len + i - 1;
        coefficient = coefficients(i);
        window = input(i:j) * coefficient;
        estimates = estimates + window;
    end
    e = estimates;
end
