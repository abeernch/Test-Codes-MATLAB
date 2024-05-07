x = 1e3*(1 : length(rx.interleaved))./fs;
f = figure;
ax = axes(f);

j = 1;
ratio = length(rx.interleaved)/100;

warning('off')

for i = 1 : 100
    
    plot(x(j: ratio*i),rx.interleaved(j: ratio*i))
    grid on;
    ax.XLimMode = 'manual'; ax.YLimMode = 'manual';
    ax.XLim = ([0 x(end)]); ax.YLim = ([-40 0]);  
    title('Interleaved Interception from transmitters');
    xlabel('Time (ms)'); ylabel('Signal Voltage (dBm)')
    
    j = ratio + 1;
    drawnow
   
end