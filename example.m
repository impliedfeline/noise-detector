topTime = 0.25;
t = (0:dt:StopTime-dt)';
F = 60;
data = sin(2*pi*F*t);

m = fitAr(data, dt, 20);
e = walkForwardEstimate(m, data);
order = numel(m.Report.Parameters.ParVector);
% the estimate starts from the order + 1th element of the original array, since
% the first order elements are only used to predict
window = data(order + 1:(numel(data))); 
plot(window);
hold on
plot(e);
hold off
