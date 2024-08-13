% A script that uses uifigure, uicontrol and uibuttons to create an
% interactive plotting for superpositioning of two sinusoids.
% Define a grandparent (uifigure) a parent(uipanel) and children(buttons
% etc)
clear;clc;close all
function myplot

    f = uifigure;
    f.HandleVisibility = 'on'; % Turn on handle visibility to be able to close uifigures using ''close all''
    f.Name = 'Interactive Sinusoid Plotting';
    f.Units = 'normalized';

    % Set axes
    ax = axes(f);
    ax.Position = [0.4 0.35 0.55 0.45];
    ax.GridLineStyle = '-';
    ax.Title.String = 'Superposition of two sinusoids';
    ax.Title.Color = [0.94 0.8 0.6];
    ax.XLabel.String = 'Time (s)';
    ax.YLabel.String = 'Amplitude';
    grid on;

    % Add UI Panel
    ui_p = uipanel(f,"BackgroundColor",[0.9 0.9 0.95], "Title",'Signal Parameters','Position',[30 65 150 300]);
    ui_p.TitlePosition = 'centertop';
    
    % Add controls and buttons to the UI Panel
    ui_c_f1 = uieditfield(ui_p,'numeric','Editable','on','Value',1,'Position',[51 220 50 25],'HorizontalAlignment','left','Limits',[1 10]);
    ui_c1l = uilabel(ui_p,"BackgroundColor",[0.96 0.96 0.96],"Text",' f1 = ','Position',[20 220 31 25]);

    ui_c_f2 = uieditfield(ui_p,'numeric','Editable','on','Value',1,'Position',[51 190 50 25],'HorizontalAlignment','left','Limits',[1 10]);
    ui_c12 = uilabel(ui_p,"BackgroundColor",[0.96 0.96 0.96],"Text",' f2 = ','Position',[20 190 31 25]);

    ui_c_phase = uidropdown(ui_p,"Items",{'In-Phase','Out of phase','90 deg'},'Position',[51 160 80 25]);
    ui_c13 = uilabel(ui_p,"BackgroundColor",[0.96 0.96 0.96],"Text",'PD = ','Position',[20 160 31 25]);

    ui_bt = uibutton(ui_p,'Text','Update','Position',[40 100 50 25]);
    ui_bt.ButtonPushedFcn = @run;

    % Add a display for the simulation elapsed time

    ui_c14 = uilabel(ui_p,"BackgroundColor",[0.96 0.96 0.96],"Text",'Sim Time (s): ','Position',[10 60 85 25]);

% for i = 1:0.01:length(x)
    ui_c15 = uilabel(ui_p,"BackgroundColor",[0.96 0.96 0.96],"Text",num2str(2),'Position',[95 60 20 25]);
%     drawnow
% end

d = uiprogressdlg(f,"Cancelable","on","Message",'Loading','Value',[0.5],'Indeterminate','on','CancelText','fdfd');
pause(1)
close(d)

% Callbacks
% Run simulation
function run(src,event)

x = 0:0.01:1;

h1 = animatedline;
h1.MaximumNumPoints = 100;
h1.Marker = '_';
h1.Color = 'b';

h2 = animatedline;
h2.Color = 'g';

h3 = animatedline;
h3.Color = 'r';

axis([0 1 -2 2])

for i = 1:length(x)
    sig1 = sin(2*pi*ui_c_f1.Value.*x(i) - pi); 
    sig2 = sin(2*pi*ui_c_f2.Value.*x(i));
    sig3 = sig2 + sig1;

    addpoints(h1,x(i),sig1)
    addpoints(h2,x(i),real(sig2))
    addpoints(h3,x(i),real(sig3))
    grid on
    drawnow
   
end


end



end