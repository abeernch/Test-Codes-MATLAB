%% Bandwidth ESM Simulation (PDW)
% This script determines the bandwidth of the IQ signals received from the
% 03 transmitters of the ESM Simulation

%%%% Notes:
% 1. This version cannot determine the bandwidth of an LFM pulse
% 2. This approach is inspired from the MATLAB function "POWERBW"   
% gives the 3-dB (or any other) bandwidth for any type of IQ Signal.
% 3. the "POWERBW" can also determine the BW of an LFM signal

%%%% INFO
% Author: Abeer Nasir Chaudhry
% Date created: 220120
% Latest Mod Date = 220120 
% Version: 2.0

%%
inc = 0.0240*max([size(rx.rxsig1,1) size(rx.rxsig2,1) size(rx.rxsig3,1)]); % initialize an increment to the psd vector

psd = zeros(inc+max([size(rx.rxsig1,1) size(rx.rxsig2,1) size(rx.rxsig3,1)]), ...
     max([size(rx.rxsig1,2) size(rx.rxsig2,2) size(rx.rxsig3,2)])); % initialize psd matrix

b_width = zeros((max([length(unique_pw) length(unique_amp) length(unique_prf)])) ...
    ,max([tx1.pulses tx2.pulses tx3.pulses]));% initialize bandwidth storage vector

f_c = zeros((max([length(unique_pw) length(unique_amp) length(unique_prf)])) ...
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
      
    [psd,f] = pwelch(sig,[],[],fs); % This is the psd
   
    ref = max(db(abs(psd)));                                 % Get the reference signal magnitude
    lim = ref-3;                                             % Get the 3dB less of the reference
    
    ind_ref = find(db(abs(psd)) == ref);                     % Find the index of the reference magnitude
    ind_ref = round(gradient(ind_ref)./2);                   % Process the indices for the ref magnitude for all pulses
   
    
    [~,ind_lim] =  min(abs(lim - db(abs(psd))));             % Find the index of the 3dB less magnitude
    ind_lim = round(abs(diff(ind_lim))./2);
    ind_lim(1,end+1) = round((mean(ind_lim)));
    
    f_c(j,1:length(ind_ref)) = f(ind_ref)
    f_l = f(ind_lim);
   
    band_width = abs(f_c(j,1:length(ind_ref)) - f_l.') % Bandwidth in GHz
    
    b_width(j,1:length(band_width)) = band_width

    figure
    plot(f,db(abs(fftshift(psd))))
    grid on; xlabel('Frequency (GHz)'); ylabel('Power-Freq response (dB/Hz)');
    title('Signal PSD Tx -',num2str(j))

end
%% Pulse characterization
% Next step is to apply a few conditions to determine whether or not pulse 
% compression is implemented. % In the chunk of code below, this is done by
% taking the time-bandwidth product of each pulse. If the bt == 1, it is a 
% simple pulse, otherwise it is compressed. Also, the mean center frequency
% of each transmitter is determined for all its pulses.

% The way the code behaves is as follows: The for loop is set to run equal
% to the number of types of signal detected, this is specified by either
% the amp,pw or prf of the pulses. Even if two characteristics are the
% same, one will differ exposing the redundancy. Owing to the dynamics of
% the simulation,signal from the 03 transmitters may reach in any order.
% For each iteration, the detected signals pulse width is compared to that
% of each transmitter so that the TB product can be computed for the
% corresponding transmitter. Also, the mean center frequency is computed
% per transmitter this way.

i = 0;

for i = 1 : max([length(unique_pw) length(unique_amp) length(unique_prf)])
    if i == 1 
        if round(unique_pw(i),8,"decimals") == round(tx1.tau,8,'decimals')
            bw_check(i) = mean(b_width(i, 1:tx1.pulses))*1e6*unique_pw(i);
            fc(i) = mean(f_c(i, 1:tx1.pulses));

        elseif round(unique_pw(i),8,"decimals") == round(tx2.tau,8,'decimals')
            bw_check(i) = mean(b_width(i, 1:tx2.pulses))*1e6*unique_pw(i);
            fc(i) = mean(f_c(i, 1:tx2.pulses));

        elseif round(unique_pw(i),8,"decimals") == round(tx3.tau,8,'decimals')
            bw_check(i) = mean(b_width(i, 1:tx3.pulses))*1e6*unique_pw(i);
            fc(i) = mean(f_c(i, 1:tx3.pulses));
        end
    end

    if i == 2 
        if round(unique_pw(i),8,"decimals") == round(tx1.tau,8,'decimals')
            bw_check(i) = mean(b_width(i, 1:tx1.pulses))*1e6*unique_pw(i);
            fc(i) = mean(f_c(i, 1:tx1.pulses));

        elseif round(unique_pw(i),8,"decimals") == round(tx2.tau,8,'decimals')
            bw_check(i) = mean(b_width(i, 1:tx2.pulses))*1e6*unique_pw(i);
            fc(i) = mean(f_c(i, 1:tx2.pulses));

        elseif round(unique_pw(i),8,"decimals") == round(tx3.tau,8,'decimals')
            bw_check(i) = mean(b_width(i, 1:tx3.pulses))*1e6*unique_pw(i);
            fc(i) = mean(f_c(i, 1:tx3.pulses));
        end
    end

    if i == 3 
        if round(unique_pw(i),8,"decimals") == round(tx1.tau,8,'decimals')
            bw_check(i) = mean(b_width(i, 1:tx1.pulses))*1e6*unique_pw(i);
            fc(i) = mean(f_c(i, 1:tx1.pulses));
        elseif uround(unique_pw(i),8,"decimals") == round(tx2.tau,8,'decimals')
            bw_check(i) = mean(b_width(i, 1:tx2.pulses))*1e6*unique_pw(i);
            fc(i) = mean(f_c(i, 1:tx2.pulses));

        elseif round(unique_pw(i),8,"decimals") == round(tx3.tau,8,'decimals')
            bw_check(i) = mean(b_width(i, 1:tx3.pulses))*1e6*unique_pw(i);
            fc(i) = mean(f_c(i, 1:tx3.pulses));

        end
    end    
end

%% Assign character to pulses
% From the acq of the time-bandwidth product, the following conditions
% define whether a pulse is compressed or not.

for i = 1:length(bw_check)
    if bw_check(i) < 1.5 & bw_check(i) > 0.6 
        pulse_char{i} = 'Simple Pulse';
    elseif bw_check(i) > 2
        pulse_char{i} = 'Compressed Pulse';
    end
end
disp(pulse_char)
disp(fc)