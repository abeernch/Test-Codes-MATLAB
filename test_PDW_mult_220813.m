%% Sample-by-Sample PDW for single emitter 
% Reports TOAs, Pulse widths, Freq and avg pulse amplitude for a single
% emitter
close all; clear reported_toa

%% Integrated sample-by-sample Pulse parameters and TOA detection
% Set threshold
thresh = 0.0005;
fs = tx{1}.fs/1e6;
% fs = 24;

%Initialize for loop for processing data from N receivers
for r = 1 : size(channel,2)
%% Initialize variables
    qual_samp = [];
    j = []; k = 1; t = 1;
    fall_index = []; rise_index = []; prev_rise = [];
    
    % No. RaddarDD1vnts for FFT
    n_pts = 2^15;  
    
    %% Start sample-by-sample detection algo
    for i = 1:length(channel(:,r))
        
        sample = channel(i,r);
    
        % Rising/falling edge detection
        chk = abs(sample) > thresh;
        if isempty(qual_samp)    
            if chk == 1
                qual_samp = i;
                j = 1;
            end
            continue
        elseif ~isempty(qual_samp) && chk == 0
            qual_samp = i;
            j = 2;
        end
       
    %% Rising/falling edge reporting
        if ~isempty(qual_samp) && mod(j,2) == 1 && qual_samp ==i-1
            rise_index = qual_samp;
    
            if ~isempty(prev_rise) && rise_index ~= prev_rise
                toa = rise_index - prev_rise + toa;
            else
                toa = rise_index;
            end
            reported_toa{r}(k) = toa;
            
        elseif ~isempty(qual_samp) && mod(j,2) == 0
            fall_index = qual_samp;
        end
    
    %% Pulse detection and Reporting
        if ~isempty(fall_index) && ~isempty(rise_index)
            
            %% Report Pulse-width
            pw = fall_index - rise_index;
            reported_pw{r}(k) = pw;
            
            %% Report Average Pulse Amplitude
            avg_ampl = mean(abs(channel(rise_index : fall_index,r)));
            reported_amp{r}(k) = avg_ampl;
    
            % Add additional logic to store the pulse samples where the
            % detected voltage is maximum. These samples will be used to access
            % the IQ samples for presentation
            if k > 1
                if reported_amp{r}(k) > reported_amp{r}(k-1)
                    max_rise = rise_index;
                    max_fall = fall_index;
                end
            end
    
            %% Report Frequency
            [~,freq] = max(db(abs(fftshift(fft(channel(rise_index:fall_index,r),n_pts)))));
            scaled_freq = (freq - n_pts/2)*fs*1e6/n_pts;
            reported_freq{r}(k) = scaled_freq;
    
            k = k+1;
            
            % Update variables/incrementors
            prev_rise = rise_index;
            qual_samp = [];fall_index = []; rise_index = [];
        end
    end

    pdw{r} = [];
    pdw{r}(:,1) = reported_toa{r}; 
    pdw{r}(:,2) = reported_freq{r};
    pdw{r}(:,3) = reported_amp{r};
    pdw{r}(:,4) = reported_pw{r};
    
    %% Visual Presentation of data
    % Plot PRI
    figure; scatter((1:length(reported_toa{r})-1), diff(reported_toa{r})./fs,"LineWidth",1)
    ylim([min(diff(reported_toa{r})./fs) - min(diff(reported_toa{r})./fs) max(diff(reported_toa{r})./fs) + min(diff(reported_toa{r})./fs)])
    ylabel({'PRI';'(us)'}); xlabel('Detections'); title('Detections vs PRI');
    
    %% Plot Pulse width
    figure; scatter((1:length(reported_pw{r})), (reported_pw{r})/(fs),"LineWidth",1)
    ylim([min(reported_pw{r})./fs - min(reported_pw{r})./fs max(reported_pw{r})./fs + min(reported_pw{r}./fs)])
    ylabel({'Pulse-width';'(us)'}); xlabel('Detections'); title('Detections vs Pulse-width');
    
    %% Plot Amplitude
    figure; plot((1:length(reported_amp{r})), (reported_amp{r})*1e3,"LineWidth",1)
    ylim([min(reported_amp{r})*1e3 - min(reported_amp{r})*1e3/fs max(reported_amp{r})*1e3 + min(reported_amp{r})*1e3/fs])
    ylabel({'Pulse Amplitude';'(mV)'}); xlabel('Detections'); title('Detections vs Pulse Amplitude');
    
    %% Plot Frequency
    figure; scatter((1:length(reported_freq{r})), abs(reported_freq{r})./1e6,"LineWidth",1)
    % ylim([min(reported_freq{r})/1e7 - min(reported_freq{r})/1e7 min(reported_freq{r})/1e7 + min(reported_freq{r})/1e7])
    ylabel({'Intermediate Frequency';'(MHz)'}); xlabel('Detections'); title('Detections vs IF');
    
    %% Plot waveform
    % Use the incrementors and flags to select the sample range
    % corresponding to the pulse where avg amplitude is max. For those samples,
    % access and plot IQ waveform. The 
    % Principle axis    
    if ~isempty(max_rise) &&  ~isempty(max_fall)
        figure;plot((1:length(channel(max_rise:max_fall,r))),(channel(max_rise:max_fall,r)*1e3))
        ylabel({'IQ Data';'(mV)'}); xlabel('Samples'); title('IQ Data');
    end
    
    %% Plot envelope
    figure;plot((1:length(channel(max_rise:max_fall,r))),abs(channel(max_rise:max_fall,r)*1e3))
    ylabel({'Pulse Amplitude';'(mV)'}); xlabel('Samples'); title('Pulse Envelope');
    
    %% Doppler (from the max amplitude pulse)
    if tx{1}.platformType ==1
        fax = linspace(-fs*1e6/2,fs*1e6/2,2^14);
        figure;plot(fax./1e6,db(abs(fftshift(fft(channel(max_rise:max_fall,r),2^14)))));
        ylabel({'Gain';'(dB)'}); xlabel({'Frequency';'MHz'}); title('Doppler of the max avg amplitude pulse');
    
    % Speed2Dop of gndspeed
        resampled_gndspd = interp((tx{1}.gndspeed),ceil(length(reported_freq{r})/length(tx{1}.gndspeed)));
        resampled_gndspd = resampled_gndspd(1:length(reported_freq{r}));
        figure;plot(1:length(resampled_gndspd),(speed2dop(resampled_gndspd,3e8/tx{1}.fo))./(1e6))
        ylabel({'Doppler Frequency';'(MHz)'}); xlabel({'Detections'}); title('GroundSpeed Reference');
    
    % Doppler from all detected pulses
        figure; plot((1:length(reported_freq{r})), (reported_freq{r})./1e6*2)
        ylabel({'Doppler Frequency';'(MHz)'}); xlabel({'Detections'}); title('Detected Doppler Frequency');
    %     ax = gca; ax.YDir = 'reverse';
    end
end

%% Demonstration of Propagation delay using 02 Sensors
r1_toa = reported_toa{1}(1)./24e6;
r2_toa = reported_toa{1}(1)./24e6;
range_r1 = time2range(r1_toa)*2;
range_r2 = time2range(r2_toa)*2;