# Noise detector for EEG data
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
