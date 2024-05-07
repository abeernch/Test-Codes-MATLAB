function test_myplot
    close all;clc
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
    % freq 1 selector
    ui_c_f1 = uieditfield(ui_p,'numeric','Editable','on','Value',1,'Position',[51 220 50 25],'HorizontalAlignment','left','Limits',[0.1 10]);
    ui_c1l = uilabel(ui_p,"BackgroundColor",[0.96 0.96 0.96],"Text",' f1 = ','Position',[20 220 31 25]);

    % freq 2 selector
    ui_c_f2 = uieditfield(ui_p,'numeric','Editable','on','Value',1,'Position',[51 190 50 25],'HorizontalAlignment','left','Limits',[0.1 10]);
    ui_c12 = uilabel(ui_p,"BackgroundColor",[0.96 0.96 0.96],"Text",' f2 = ','Position',[20 190 31 25]);

    % Phase selector
    ui_c_phase = uidropdown(ui_p,"Items",{'In-Phase','Out of phase','90 deg'},'Position',[51 160 80 25]);
    ui_c13 = uilabel(ui_p,"BackgroundColor",[0.96 0.96 0.96],"Text",'PD = ','Position',[20 160 31 25]);

    % Time selector
    ui_c_t = uieditfield(ui_p,'numeric','Editable','on','Value',1,'Position',[60 130 40 25],'HorizontalAlignment','left','Limits',[0.1 10]);
    ui_c14 = uilabel(ui_p,"BackgroundColor",[0.96 0.96 0.96],"Text",' Time = ','Position',[20 130 45 25]);

    % Start button
    ui_btu = uibutton(ui_p,'Text','Update','Position',[20 20 50 25]);
    ui_btu.ButtonPushedFcn = @run;
    
    % Reset button
    ui_btr = uibutton(ui_p,'Text','Clear','Position',[80 20 50 25]);
    ui_btr.ButtonPushedFcn = @claxis;

    % Pause button
    ui_btp = uiswitch(ui_p,"toggle",'Position',[60 55 50 25],'Items',{'Pause','Resume'});
    ui_btp.Orientation ='horizontal';
    ui_btp.ValueChangedFcn = @pausesim;

    % Add a display for the simulation elapsed time
    ui_c15 = uilabel(ui_p,"BackgroundColor",[0.96 0.96 0.96],"Text",'Sim Time (s): ','Position',[20 90 85 25]);
    uiimage(f,"ImageSource","abc.jpeg","Position",[300 10 100 100]);
d = uiprogressdlg(f,"Cancelable","on","Message",'Loading','Value',0.5,'Indeterminate','on','CancelText','fdfd');
pause(1)
close(d)

%% Callbacks

    function pausesim(~,~)
        switch ui_btp.Value
            case 'Pause'
                pause
            case 'Resume'
                
        end
    end

% Run simulation
function claxis(~,~)
    cla(ax)
end

    function run(~,~)

    x = 0:0.01:ui_c_t.Value;
    
    h1 = animatedline;
    h1.MaximumNumPoints = 100;
    
    h1.Color = 'b';
    
    h2 = animatedline;
    h2.Color = 'g';
    
    h3 = animatedline;
    h3.Color = 'r';
    h3.Marker = '_';
    
    axis([0 ui_c_t.Value -2 2])
    
    switch ui_c_phase.Value
        case 'Out of phase'
            phase = pi;
        case 'In-Phase'
            phase = 0;
        case '90 deg'
            phase = pi/2;
    
    end
    
        for i = 1:length(x)
            sig1 = sin(2*pi*ui_c_f1.Value.*x(i) - phase); 
            sig2 = sin(2*pi*ui_c_f2.Value.*x(i));
            sig3 = sig2 + sig1;
    
            addpoints(h1,x(i),sig1)
            addpoints(h2,x(i),real(sig2))
            addpoints(h3,x(i),real(sig3))
        
            uilabel(ui_p,"BackgroundColor",[0.96 0.96 0.96],"Text",num2str(x(i)),'Position',[105 90 30 25]);
            drawnow
       
        end
    end
end
