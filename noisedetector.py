import numpy as np
from statsmodels.tsa.ar_model import AR

class NoiseDetector:
    
    def __init__(self, data):
        self.model = AR(data).fit()
        print(self.model.k_ar)

    def find_error(self, data):
        order = self.model.k_ar
        if len(data) <= order:
            raise ValueError('data length needs to be greater than model order')
        predictions = np.zeros(len(data) - order)
        for i, coefficient in enumerate(self.model.params):
            if i < order:
                predictions += data[i:-order+i] * coefficient
            else:
                predictions += data[i:] * coefficient
        squared_error = (data[order:] - predictions) ** 2
        index = np.arange(order, len(data))
        return np.vstack((index, squared_error))


