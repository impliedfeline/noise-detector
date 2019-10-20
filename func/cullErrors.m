function s = cullErrors(errors, threshold)
    s = errors(errors(:,1) >= threshold,:);
end