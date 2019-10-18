import numpy as np
import pandas as pd
from statsmodels.tsa.ar_model import AR

class NoiseDetector:
    
    def __init__(self, data):
        self.model = AR(data).fit()
        print('Model order: %s' % self.model.k_ar)

    def walk_forward_forecast(self, data):
        order = self.model.k_ar
        if len(data) <= order:
            raise ValueError('data length needs to be greater than model order')
        prediction = np.zeros(len(data) - order)
        for i, coefficient in enumerate(self.model.params):
            end = i - order if i - order < 0 else len(data)
            prediction += data[i:end] * coefficient
        actual = data[:-order]
        squared_error = (actual - prediction) ** 2
        index = np.arange(order, len(data))
        frame = pd.DataFrame(
                data=np.vstack((actual, prediction, squared_error)).T,
                index=index,
                columns=['actual', 'prediction', 'squared_error'])
        frame.index.name = 'sample_index'
        return frame

def cull_error(frame, threshold=-1, percentage=-1, amount=-1):
    frame = frame.sort_values(by=['squared_error'], ascending=False)
    if threshold > -1:
        frame = frame[frame['squared_error'] < threshold]
    elif percentage > -1:
        frame = frame.head(int(len(frame) * (percentage / 100)))
    elif amount > -1:
        frame = frame.head(amount)
    frame = frame.sort_index()
    return frame

