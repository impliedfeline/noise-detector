import numpy as np
from pandas.plotting import autocorrelation_plot
import matplotlib.pyplot as plt
from noisedetector import NoiseDetectorUni, NoiseDetectorMulti, cull_error

def sinfreq(freq, sample):
    return np.sin(np.linspace(-np.pi * freq, np.pi * freq, sample))

def testdata(sample):
    mu, sigma = 1, 1
    y = sinfreq(1, sample) * sinfreq(2, sample) * sinfreq(4, sample) \
        * np.random.normal(mu, sigma, sample)
    return y

# initialize some test data
y = testdata(1000)

# shows autocorrelation of data; if data is autocorrelated, it's a candidate for
# autoregression of some order p
autocorrelation_plot(y)
plt.show()

# train autoregressive model, perform walk forward forecast and take 10% of
# largest errors
train, test = y[:len(y)-200], y[len(y)-200:]
detector = NoiseDetectorUni(train)
actual, prediction, result = detector.walk_forward_forecast(test)

plt.plot(actual, label='actual')
plt.plot(prediction, label='prediction')
for i, _ in cull_error(result, percentage=10).iterrows():
    plt.axvline(x=i, color='pink')
plt.legend(loc='upper left')
plt.show()

# multivariate case
y = np.vstack((testdata(1000), testdata(1000), testdata(1000))).T

autocorrelation_plot(y[:,0])
autocorrelation_plot(y[:,1])
autocorrelation_plot(y[:,2])
autocorrelation_plot(y)
plt.show()

train, test = y[:len(yV)-200], y[len(y)-200:]
detector = NoiseDetectorMulti(train)
actual, prediction, result = detector.walk_forward_forecast(test)

fig, ax = plt.subplots(nrows=3)
ax[0].matshow(actual.T, label='actual')
ax[1].matshow(prediction.T, label='prediction')
for i, _ in cull_error(result, percentage=10).iterrows():
    ax[2].axvline(x=i, color='red')
plt.show()
