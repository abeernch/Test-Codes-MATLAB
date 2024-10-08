clear 
close all
%% TDOA Implementation
%parameters
range_s = 30; %sensor range for each dimension
range_T = 300; %target range for each dimension
c = 3e8;    %the speed of light
M = 5;      %number of sensors

E = linspace(30,0.1,10000); 

method_flag = 1;    %TDOA method flag, 0 for linear 1 for Taylor 

in_est_error = 200;  %initial estimate error std in meter
trials = 50;
fail_thr = 1e3;   % threshold for fail of estimator

RMSE = zeros(length(E),1);
x_nonlin = zeros(3,M);

P = zeros(3,M); %includes all sensor positon vectors
%sensor positon vectors
for ii=1:M
    P(:,ii)= range_s*2*(rand(3,1)-0.5);
end

p_T = range_T*2*(rand(3,1)-0.5);   %target positon vector

err_std = 1e-10; %tdoa measurement error std in sec

%finding TOAs 
dummy = repmat(p_T,1,M)-P;
toa = zeros(M,1);   %includes all toa information

for ii = 1:M
    toa(ii) = norm(dummy(:,ii))/c;    
end

tdoa = toa-toa(1); tdoa(1)=[];
tdoa = tdoa + err_std*randn(M-1,1);

for m = 1:length(E)
    rmse = zeros(trials,1);
        for k=1:trials

            if method_flag == 0
                %%% Linear Solution
                p_1 = P(:,1);
                dummy = P(:,2:M)';
                A = 2*[(p_1(1)-dummy(:,1)), (p_1(2)-dummy(:,2)), (p_1(3)-dummy(:,3)), -c*tdoa];
                b = (c*tdoa).^2 + norm(p_1)^2 - sum((dummy.^2),2);
                x_lin = pinv(A)*b;
                rmse(k) = norm(p_T-x_lin(1:3))^2;
            else
                %%% Taylor Series Expansion Solution
                p_T_0 = p_T + in_est_error*randn(3,1);    %initial estimate with some error (penalty term)
                d = c*tdoa;
                f = zeros(M-1,1);
                del_f = zeros(M-1,3);
                
                for ii=2:M
                   f(ii-1)=norm(p_T_0 - P(:,ii)) - norm(p_T_0-P(:,1)); 
                   del_f(ii-1,1) = (p_T_0(1)-P(1,ii))*norm(p_T_0-P(:,ii))^-1 - (p_T_0(1)-P(1,1))*norm(p_T_0-P(:,1))^-1;
                   del_f(ii-1,2) = (p_T_0(2)-P(2,ii))*norm(p_T_0-P(:,ii))^-1 - (p_T_0(2)-P(2,1))*norm(p_T_0-P(:,1))^-1;
                   del_f(ii-1,3) = (p_T_0(3)-P(3,ii))*norm(p_T_0-P(:,ii))^-1 - (p_T_0(3)-P(3,1))*norm(p_T_0-P(:,1))^-1;    
                end
            
            x_nonlin(:,k) = pinv(del_f)*(d-f)+p_T_0;
            rmse(k) = norm(p_T-x_nonlin)^2;
            end
        end
        fails = sum(rmse > fail_thr^2);
        RMSE(m) = sqrt(mean(rmse(rmse < fail_thr^2)));
end 

figure
plot(E*1e-10,RMSE);
ylabel('RMSE (m)');
xlabel('\sigma_e (sec)')
%%
% 
% %shows the sensor position, target and estimation 
figure
plot3(P(1,:), P(2,:),P(3,:),'o'); hold on;
plot3(p_T(1), p_T(2),p_T(3),'k*');
xlim([-range_T range_T]);ylim([-range_T range_T]);zlim([-range_T range_T]);
xlabel('x-axis'); ylabel('y-axis'); zlabel('z-axis');

if ~method_flag
    plot3(x_lin(1), x_lin(2),x_lin(3),'md','MarkerSize',7.75);  %target estimate with linear solution
else
    plot3(x_nonlin(:,end), x_nonlin(:,end),x_nonlin(:,end),'ms','MarkerSize',7.75); 
end
legend('Sensor Positions', 'Target Position', 'Target Estimation')
grid on; 
hold off;
