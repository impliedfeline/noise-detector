import numpy as np
from pandas.plotting import autocorrelation_plot
import matplotlib.pyplot as plt
from statsmodels.tsa.ar_model import AR
from noisedetector import NoiseDetector, cull_error

def sinfreq(freq, sample):
    return np.sin(np.linspace(-np.pi * freq, np.pi * freq, sample))

# initialize some test data
sample = 1000
mu, sigma = 1, 0.1
y = sinfreq(1, sample) * sinfreq(2, sample) * sinfreq(4, sample) \
    * np.random.normal(mu, sigma, sample)
train, test = y[:len(y)-200], y[len(y)-200:]

# shows autocorrelation of data; if data is autocorrelated, it's a candidate for
# autoregression of some order p
autocorrelation_plot(y)
plt.show()

# train autoregressive model, perform walk forward forecast and take 10% of
# largest errors
detector = NoiseDetector(train)
result = detector.walk_forward_forecast(test)

plt.plot(result['actual'], label='actual')
plt.plot(result['prediction'], label='prediction')
for i, _ in cull_error(result, percentage=10).iterrows():
    plt.axvline(x=i, color='pink')
plt.legend(loc='upper left')
plt.show()

