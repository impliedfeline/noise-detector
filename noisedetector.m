function m = fitAr(data, sampleTime, maxOrder)
    id = iddata(data, [], sampleTime);    
    models = cell(maxOrder,1);
    for ord = 1:maxOrder
        models{ord} = ar(id, ord);
    end
    V = aic(models{:},'AICc');
    [Vmin,I] = min(V);
    m = models{I};
end

function e = walkForwardEstimate(model, input)
    coefficients = model.Report.Parameters.ParVector;
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

function s = squaredErrorsOfWalkForward(actual, estimate)
    order = numel(actual) - numel(estimate);
    window = actual(order + 1:numel(actual));
    errors = (window - estimate).^2;
    errors = [errors (order+1:numel(actual)).'];
    s = errors;
end

function s = cullErrors(errors, threshold)
    s = errors(errors(:,1) >= threshold,:);
end
