%plotnoise() 

% Inputs:
%     model 
%     nchan - the number of estimated channels
%     dur   - duration per segment
%     srate - sample rate
%     n_var - number of variance for threshold
%     plotmodel - logical; if plot fit model or not

function plot = plotnoise0(EEG,model, nchan, dur, srate, n_var, plotmodel)

% nchan = 2;
% dur = 1;
% srate = 250;
% n_var = 2.5;
% plotmodel = 0;

model = model;
pnts = dur*srate;
rate = [];
    for m = 1:nchan;
        num = numel(EEG.data(m, :))/pnts; % get the number of 1 sec segments (250 Hz);
        for n = 1: floor(num)
            data     = double(EEG.data(m,(pnts*(n-1)+1):pnts*n)).';
            
            % get estimate and errors
            estimate = walkForwardEstimate(model, data);
            order    = numel(model.Report.Parameters.ParVector);
            window   = data(order + 1:numel(data));
 
            % get cull
            errors   = errorsOfWalkForward(data, estimate);
            threshold =  mean(errors(:,1)) + n_var * std(errors(:,1));
            culled   = cullErrors(errors, threshold);            
            rate(m,n) = numel(culled(:,1))/ pnts;
            
            %% plot model
            if plotmodel == 1,
                fig = figure;
                hax = axes;
                hold on
                plot(window);
                plot(estimate);
                
                for i = 1:size(culled,1)
                    sample = culled(i,2);
                    line([sample sample],get(hax,'YLim'))
                end
                hold off
                
            end  
        end       
    end
    
    
%% 

seg_full = [];
for i = 1: length(rate(1,:));
    error_n = length(find(rate(:,i)));
    
    if error_n/length(rate(:,i)) > 0.3;
        seg_full = [seg_full i];
        
    end

end
seg_single = ceil(rate);
segchanind = 1:128;

rejesegcol =  [255/255 0.8 255/255];
rejeseg = zeros(1,size(rate,2));
rejeseg(seg_full) = ones(1,length(seg_full));
rejesegE = zeros(EEG.nbchan,size(rate,2));

for i = 1:size(seg_single, 1);
    rejesegE(i, :) = seg_single(i,:);
    
end


winrej=markbadsegment(rejeseg,rejesegE,pnts,rejesegcol);

  plot = eegplot( EEG.data,  'winlength', 10, 'dispchans', 60, 'spacing',60, 'winrej', winrej)

