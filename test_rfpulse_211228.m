clear;clc
% RF induced modulations

fs =1e6;
mod = input('Modulation ("pulse","lfm","barker"): ','s');

pw = 100e-6;
tau_sim = ones(1,round(fs*pw));
pri = zeros(1,fs*1e-3);

switch mod
    case 'pulse'
        rf = sin(2*pi*1e9*(linspace(0,1,length(tau_sim))));
        wf = tau_sim.*rf;
        pri(1000:1000+length(tau_sim)-1) = wf;

    case 'lfm'
        pcr = input('PCR = ');
        lfm = [exp(-1i*pi*pcr.*(linspace(0,1,length(tau_sim)/2)).^2) fliplr(exp(1i*pi*pcr.*(linspace(0,1,length(tau_sim)/2)).^2))];
        wf = tau_sim.*lfm;
        pri(1000:1000+length(tau_sim)-1) = wf;
end


figure
plot((1:length(pri))./fs,pri);

%% Barker code
bar_seq = comm.BarkerCode("Length",1,"SamplesPerFrame",length(tau_sim));
rf = sin(2*pi*1e9*(linspace(0,1,length(tau_sim))));
wf = (rf.*bar_seq().');
pri(5000:5000+length(tau_sim)-1) = wf;
figure
plot((1:length(pri))./fs,pri);
