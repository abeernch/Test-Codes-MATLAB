pos = [50e2;100e3;0];
th = linspace(-pi,pi,360);
r= 50e3:50e3:500e3;
% figure

for i = 1:length(r)
    xunit = r(i) * cos(th) + pos(1);
    yunit = r(i) * sin(th) + pos(2);
    txt = sprintf('%2.0f km',r(i)/1e3);
    p = plot(xunit, yunit,'LineStyle',':','LineWidth',1,'Color','k',DisplayName=txt);
    text(mean(xunit),max(yunit),txt,"FontSize",6)
    hold on
    axis equal
end