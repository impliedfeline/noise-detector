

%% get train data and predict model
home_path = 'D:\UH\data_analysis\school_intervention_study_data\EEG_data\double_check_0815\1_chan_corr_maha_pre2\'
file_struct = dir([home_path '*.set'])
len = length(file_struct );
 for i = 1:len
    subject_list{i}=file_struct(i).name;
 end
subject = subject_list{1};

EEG = pop_loadset('filename',subject, 'filepath',home_path);

cleanData = double(EEG.data(:)).';
model = fitAr(cleanData, 1/500, 1);
%% plot estimation for clean data

data = double(EEG.data(1,:)).';
estimate = walkForwardEstimate(model, data);
order = modelOrder(model);
% the estimate starts from the order + 1th element of the original array, since
% the first order elements are only used to predict
window = data(order + 1:numel(data));
errors = errorsOfWalkForward(data, estimate);
threshold =  mean(errors(:,1)) + n_var * std(errors(:,1));
culled   = cullErrors(errors, threshold);  

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



%% get test data

 home_path = 'D:\UH\data_analysis\school_intervention_study_data\EEG_data\data_science_course\set\filt\';
file_struct = dir([home_path '*.set'])
len = length(file_struct );
 for i = 1:len
    subject_list{i}=file_struct(i).name;
 end
 
 %%

for s = 1;
    subject = subject_list{s};
    EEG     = pop_loadset('filename',subject, 'filepath',home_path); 
    
    nchan   = 2;   % the number of estimated channels
    dur     = 1;   % duration per segment
    srate   = 500; % sample rate
    n_var   = 2.5;   % number of variance for threshold
    plotmodel = 0;   % logical; if plot fit model or not
    
    plot = plotnoise0(EEG,model, nchan, dur, srate, n_var, plotmodel)
end


