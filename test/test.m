

%% create subject list
home_path = 'D:\UH\data_analysis\school_intervention_study_data\EEG_data\double_check_0815\1_chan_corr_maha_pre2\'
file_struct = dir([home_path '*.set'])
len = length(file_struct );
 for i = 1:len
    subject_list{i}=file_struct(i).name;
 end


%% load data
s = 1;
subject = subject_list{s};

EEG = pop_loadset('filename',subject, 'filepath',home_path);

%% 
data = double(EEG.data(1,1:5000)).';
model = fitAr(data, 1/500, 20);

estimate = walkForwardEstimate(model, data);
order = numel(model.Report.Parameters.ParVector);
% the estimate starts from the order + 1th element of the original array, since
% the first order elements are only used to predict
window = data(order + 1:numel(data));
errors = errorsOfWalkForward(data, estimate);
culled = cullErrors(errors, 100);
fig=figure; 
hax=axes; 
hold on
plot(window);

%% plot estimate
plot(estimate);

%%  plot error
for i = 1:size(culled,1)
		sample = culled(i,2);
		line([sample sample],get(hax,'YLim'))
        alpha(0.3)
end
hold off
