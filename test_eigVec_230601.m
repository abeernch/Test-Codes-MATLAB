clear ;
s  = [2 2] 
set = randn(200,1);
x = normrnd(s(1).*set,1)+3
x = zscore(x) % Standardize
y = normrnd(s(1).*set,1)+2
y= zscore(y)%Standardize
x_0 = mean(x)
y_0 = mean (y) 
c = linspace(1,100,length(x)); % color
figure
scatter(x,y,50,c,'filled')
xlabel('1st Feature : x')
ylabel('2nd Feature : y')
title('2D_dataset')

grid on
% gettign the covariance matrix 
covariance = cov([x,y]);
[eigen_vector, eigen_values] = eig(covariance);
eigen_vector_1 = eigen_vector(:,1);
eigen_vector_2 = eigen_vector(:,2);
d = sqrt(diag(eigen_values));

hold on;
% quiver(x_0,y_0,eigen_vector(1,2),eigen_vector(2,2),d(2),'k','LineWidth',5);
% quiver(x_0,y_0,eigen_vector(1,1),eigen_vector(2,1),d(1),'r','LineWidth',5);
quiver(x_0,y_0,eigen_vector_1(1),eigen_vector_2(2),d(1),'k','LineWidth',5);
quiver(x_0,y_0,eigen_vector_2(1),eigen_vector_2(2),d(2),'r','LineWidth',5);

hold off;