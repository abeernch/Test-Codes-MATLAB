clear;clc;close all

x = 0:0.01:1000;

h1 = animatedline;
% h1.MaximumNumPoints = 100;
h1.Marker = '_';
h1.Color = 'b';
h1.DisplayName = 'dsd';
h2 = animatedline;
h2.Color = 'g';
h3 = animatedline;
h3.Color = 'r';
h1.MaximumNumPoints = 1;
axis([0 1 -2 2])

for i = 1:length(x)
    sig1 = sin(2*pi*2.*x(i) - pi/2); %+ rand(1:length(x(i)));
    sig2 = sin(2*pi*2.*x(i));
    sig3 = sig2 + sig1;

    addpoints(h1,x(i),sig1)
    addpoints(h2,x(i),real(sig2))
    addpoints(h3,x(i),real(sig3))
    grid on
    drawnow %limitrate
   
end


%%
% tau = ones(1,10);
% pri = zeros(1,1000);
% pri(15:15+length(tau)-1) = tau;
% 
% l1 = animatedline;
% 
% for i = 1:length(pri)
%     sig = pri(i);
%     addpoints(l1,1:length(pri(i)),sig)
%     drawnow
%     pause(1)
%     grid on;
% 
% end

%%

for i = 1:length(x)
    sig1 = sin(2*pi*2.*x(i) - pi); %+ rand(1:length(x(i)));
    addpoints(h1,x(i),sig1)
    grid on
    drawnow limitrate
end
pause
for i = 1:length(x)
   sig2 = exp(2i*pi*1.*x(i));
   addpoints(h2,x(i),real(sig2))
   grid on
   drawnow 
end

pause

for i = 1:length(x)
    
    sig3 = sig2 + sig1;
    addpoints(h3,x(i),real(sig3))
    grid on
    drawnow
end
