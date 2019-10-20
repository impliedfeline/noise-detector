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
