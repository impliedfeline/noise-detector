# Noise detector for EEG data
## Introduction
To use, first train a model with ```fitAr```, which takes as its parameters the
training data, the sample time (inverse of sample rate) and the maximum order
for the autoregressive model to be trained. The function trains and tests
autoregressive models of varying orders up to the maximum order and then returns the
model with the best fit to the data. Now one can performa a walk forward estimation
on new data with ```walkForwardEstimate```, which walks over the data and produces a
one sample-ahead estimation on the data. The function ```errorsOfWalkForward``` takes
as its parameters the data that was walked over and the estimate and produces a matrix
containing the error of each estimate along with the sample index of each error in the
original data. This error matrix may be culled with the ```cullErrors``` function, which
takes as its parameters an error matrix and a threshold. All errors below the threshold
will be filtered out of the error matrix.

## Example
(The following code snippets may be found in ```example.m```.)
First, prepare some training data:
```m
% training data
sampleRate = 2048;
sampleTime = 1 / sampleRate;
stopTime = 0.25;
t = (0:sampleTime:stopTime-sampleTime)';
F = 60;
data = sin(2*pi*F*t);
```
Next, train the autoregressive model with the data
```m
% train the model
model = fitAr(data, sampleTime, 1);
estimate = walkForwardEstimate(model, data);
```
Now we may plot the errors as vertical lines using the ```line``` function
```m
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
```
