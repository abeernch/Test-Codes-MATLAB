clc;clear;close all
hFig  = figure; 
hAxis = axes(hFig);
hPlt  = plot(hAxis,rand(100,1));

% zoomObj = zoom(hAxis);
scale_x = 12539 / 83.2;
scale_y = 9216 / 62.5;
xlim_init = hAxis.XLim;
zoomObj = zoom(hAxis);
set(zoomObj, 'ActionPostCallback', {@zoomChanged, hAxis});
% zoomObj.ActionPostCallback = @(zoomObj,evd)zoomChanged( zoomObj, evd,scale_y,scale_x);
% zoomObj.Enable ='on';
xlim_f = hAxis.XLim;
uiwait(gca)
if xlim_f~= xlim_init
    uiresume
end
[x] = zoomChanged(zoomObj,[],scale_y,scale_x,hAxis);
range = linspace(x(1),x(2),length(hAxis.XAxis.TickValues));
label_updt(1:length(hAxis.XAxis.TickValues)) = ((range./scale_x))+8.05;
% for i = 1:length(hAxis.XAxis.TickValues)
%     ax.XAxis.TickLabels{i} = label_updt(i);
% end
a = sprintf('%2.5f ', label_updt);
a = a(1:end-1);
a = strsplit(a).';
hAxis.XAxis.TickLabels = a ;
uiresume


%%
clc;clear;close all
hFig  = figure; 
hAxis = axes(hFig);
hPlt  = plot(hAxis,rand(100,1));

zoomObj = zoom(hAxis);
scale_x = 12539 / 83.2;
scale_y = 9216 / 62.5;
xlim_init = hAxis.XLim;

toolbar_zoomin_OnCallback(zoomObj,[],hAxis)
range = linspace(hAxis.XLim(1),hAxis.XLim(2),length(hAxis.XAxis.TickValues));
label_updt(1:length(hAxis.XAxis.TickValues)) = ((range./scale_x))+8.05;
a = sprintf('%2.5f ', label_updt);
a = a(1:end-1);
a = strsplit(a).';
hAxis.XAxis.TickLabels = a ;