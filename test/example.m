% training data
sampleRate = 2048;
sampleTime = 1 / sampleRate;
stopTime = 0.25;
t = (0:sampleTime:stopTime-sampleTime)';
measurementError = 0.1 .* randn(sampleRate * stopTime, 1) + 1;
data = sin(4*pi*t) .* sin(16*pi*t) .* measurementError;

% train the model
model = fitAr(data, sampleTime, 1);
estimate = walkForwardEstimate(model, data);
order = modelOrder(model);
% the estimate starts from the order + 1th element of the original array, since
% the first order elements are only used to predict
window = data(order + 1:numel(data));
errors = errorsOfWalkForward(data, estimate);
threshold = 0.175;
culled = cullErrors(errors, threshold);
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
