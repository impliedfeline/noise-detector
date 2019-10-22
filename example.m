% training data
sampleRate = 2048;
sampleTime = 1 / sampleRate;
stopTime = 0.25;
t = (0:sampleTime:stopTime-sampleTime)';
F = 60;
data = sin(2*pi*F*t);

% train the model
model = fitAr(data, sampleTime, 1);
estimate = walkForwardEstimate(model, data);
order = numel(model.Report.Parameters.ParVector);
% the estimate starts from the order + 1th element of the original array, since
% the first order elements are only used to predict
window = data(order + 1:numel(data));
errors = errorsOfWalkForward(data, estimate);
culled = cullErrors(errors, 0.175);
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
