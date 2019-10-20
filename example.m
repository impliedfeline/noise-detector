fs = 2048;
dt = 1/fs;
StopTime = 0.25;
t = (0:dt:StopTime-dt)';
F = 60;
data = sin(2*pi*F*t);

model = fitAr(data, dt, 50);
estimate = walkForwardEstimate(model, data);
order = numel(model.Report.Parameters.ParVector);
% the estimate starts from the order + 1th element of the original array, since
% the first order elements are only used to predict
window = data(order + 1:numel(data));
errors = squaredErrorsOfWalkForward(data, estimate);
culled = cullErrors(errors, 0.035);
fig=figure; 
hax=axes; 
hold on
plot(window);
plot(estimate);
for i = 1:size(culled,1)
		sample = culled(i,2);
		line([sample sample],get(hax,'YLim'),'Color',[1 0 0])
end
hold off

