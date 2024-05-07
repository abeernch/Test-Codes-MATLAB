%% Bandwidth ESM Simulation (PDW)
% This script determines the bandwidth of the IQ signals received from the
% 03 transmitters of the ESM Simulation

%%%% Notes:
% 1. This version cannot determine the bandwidth of an LFM pulse
% 2. This approach is ins   
% gives the 3-dB (or any other) bandwidth for any type of IQ Signal.
% 3. the "POWERBW" can also determine the BW of an LFM signal

%%%% INFO
% Author: Abeer Nasir Chaudhry
% Date created: 220119
% Latest Mod Date = 220120 
% Version: 1.0

%%
inc = 0.0240*max([size(rx.rxsig1,1) size(rx.rxsig2,1) size(rx.rxsig3,1)]); % initialize an increment to the psd vector

psd = zeros(inc+max([size(rx.rxsig1,1) size(rx.rxsig2,1) size(rx.rxsig3,1)]), ...
     max([size(rx.rxsig1,2) size(rx.rxsig2,2) size(rx.rxsig3,2)])); % initialize psd matrix

b_width = zeros((max([length(unique_pw) length(unique_amp) length(unique_prf)])) ...
    ,max([tx1.pulses tx2.pulses tx3.pulses]));% initialize bandwidth storage vector

i = 0;
  
% use for loop to iterate through the IQ samples for each transmitter one
% by one

for j = 1 : max([length(unique_pw) length(unique_amp) length(unique_prf)])
    if j == 1 
        if round(unique_pw(j),8,"decimals") == round(tx1.tau,8,'decimals')
            sig = rx.rxsig1;
        elseif round(unique_pw(j),8,"decimals") == round(tx2.tau,8,'decimals')
            sig = rx.rxsig2;
        elseif round(unique_pw(j),8,"decimals") == round(tx3.tau,8,'decimals')
            sig = rx.rxsig3;
        end
    end

    if j == 2
        if round(unique_pw(j),8,"decimals") == round(tx1.tau,8,'decimals')
            sig = rx.rxsig1;
        elseif round(unique_pw(j),8,"decimals") == round(tx2.tau,8,'decimals')
            sig = rx.rxsig2;
        elseif round(unique_pw(j),8,"decimals") == round(tx3.tau,8,'decimals')
            sig = rx.rxsig3;
        end
    end 

    if j == 3
        if round(unique_pw(j),8,"decimals") == round(tx1.tau,8,'decimals')
            sig = rx.rxsig1;
        elseif round(unique_pw(j),8,"decimals") == round(tx2.tau,8,'decimals')
            sig = rx.rxsig2;
        elseif round(unique_pw(j),8,"decimals") == round(tx3.tau,8,'decimals')
            sig = rx.rxsig3;
        end
    end
      
    psd = periodogram(sig,[],[],fs,'centered','psd'); % This is the psd
    
    ref = pow2db(max(psd)); % Get the reference signal magnitude
    lim = ref-3;            % Get the 3dB less of the reference
    
    ind_ref = find(pow2db(psd) == ref);                     % Find the index of the reference magnitude
    ind_ref= abs(diff(ind_ref(1:end)) - ind_ref(1));        % Process the indices for the ref magnitude for all pulses
    [~,ind_lim] =  min(abs(lim - pow2db(psd(:,:))));        % Find the index of the 3dB less magnitude
   
    band_width = ind_ref' - ind_lim(1:length(ind_ref));     % find the 3dB bandwidth in terms of samples
    l1 = band_width(1) < 1;                                 % Check whether any difference of samples for all pulses is negative. 
    
        if l1 == 1                                          % Convert the samples to freq using this if any diff of samples is negative
            band_width = ((1e9.*abs(ind_ref' - ind_lim(1:length(ind_ref)))./fs)./1e6);
        end
   
        if l1 == 0                                          % Convert the samples to freq using this if NO diff of samples is negative
            band_width = ((1e9.*(ind_ref' - ind_lim(1:length(ind_ref)))./fs)./1e6)./2;
        end
    
    
    b_width(j,1:length(band_width)) = band_width            % Save the 3dB beandwidth in the vector for all pulses of the 03 transmitters
end
%% Pulse characterization
% Next step is to apply a few conditions to determine whether or not pulse 
% compression is implemented. % This is done by taking the time-bandwidth
% product of each pulse. If the bt == 1, it is a simple pulse, otherwise it
% is compressed.

i = 0;

for i = 1 : max([length(unique_pw) length(unique_amp) length(unique_prf)])
    if i == 1 
        if round(unique_pw(i),8,"decimals") == round(tx1.tau,8,'decimals')
            k = 1;
            bw_check(i) = mean(b_width(k, 1:tx1.pulses-1))*1e6*unique_pw(i);
        
        elseif round(unique_pw(i),8,"decimals") == round(tx2.tau,8,'decimals')
            k = 2;
            bw_check(i) = mean(b_width(k, 1:tx2.pulses-1))*1e6*unique_pw(i);

        elseif round(unique_pw(i),8,"decimals") == round(tx3.tau,8,'decimals')
            k = 3;
            bw_check(i) = mean(b_width(k, 1:tx3.pulses-1))*1e6*unique_pw(i);
        end
    end

    if i == 2 
        if round(unique_pw(i),8,"decimals") == round(tx1.tau,8,'decimals')
            k = 1;
            bw_check(i) = mean(b_width(k, 1:tx1.pulses-1))*1e6*unique_pw(i);

        elseif round(unique_pw(i),8,"decimals") == round(tx2.tau,8,'decimals')
            k = 2;
            bw_check(i) = mean(b_width(k, 1:tx2.pulses-1))*1e6*unique_pw(i);

        elseif round(unique_pw(i),8,"decimals") == round(tx3.tau,8,'decimals')
            k = 3;
            bw_check(i) = mean(b_width(k, 1:tx3.pulses-1))*1e6*unique_pw(i);
        end
    end

    if i == 3 
        if round(unique_pw(i),8,"decimals") == round(tx1.tau,8,'decimals')
            k = 1;
            bw_check(i) = mean(b_width(k, 1:tx1.pulses-1))*1e6*unique_pw(i);

        elseif uround(unique_pw(i),8,"decimals") == round(tx2.tau,8,'decimals')
            k = 2;
            bw_check(i) = mean(b_width(k, 1:tx2.pulses-1))*1e6*unique_pw(i);

        elseif round(unique_pw(i),8,"decimals") == round(tx3.tau,8,'decimals')
            k = 3;
            bw_check(i) = mean(b_width(k, 1:tx3.pulses-1))*1e6*unique_pw(i);
        end
    end

end


%% Assign character to pulses
for i = 1:length(bw_check)
    if bw_check(i) < 1.5 & bw_check(i) > 0.6 
        pulse_char{i} = 'Simple Pulse'
    elseif bw_check(i) > 2
        pulse_char{i} = 'Compressed Pulse'
    end
end
