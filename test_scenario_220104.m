% The objective of this script is to create a monostatic radar scenario
% with one dynamic target. This will solidify the learning of functions
% used to create the scenario. The script will also try to employ the 
% 'recieve' function to generate IQ samples at the receiver. If it does not
% work, perhaps the Phased Array toolbox initialization is necassary for
% its use.

clear;clc;close all

%% Make scenario
scene = radarScenario;
scene.StopTime = 10;
scene.UpdateRate = 1e3;

%% Create platforms

% Stationary Monostatic radar
pos_p1 = [0 0 0]*1e3;
ori_p1 = [[1 0 0];[0 0 0 ];[0 0 0]];

p1 = platform(scene,'Position',pos_p1,'Orientation',ori_p1);

% Moving airborne target
waypoint_info = [0.0   48e3 -5e3 12e3  0 0 0;
                 0.1   48e3 00e3 9e3   0 0 0;
                 0.2   48e3 05e3 8e3   0 -15 0;
                 0.3   48e3 10e3 7e3   0 -15 0;
                 0.4   48e3 15e3 6e3   0 -10 0;
                 0.5   48e3 20e3 6e3   0 0 0;
                 0.6   35e3 25e3 8e3   30 0 0;
                 0.7   30e3 30e3 8e3   30 25 0;
                 0.8   25e3 35e3 10e3  30 25 0;
                 0.9   20e3 38e3 12e3  30 25 0;
                 1     18e3 40e3 15e3  10 30 0;];


traj = waypointTrajectory("SampleRate",1e3,"TimeOfArrival",waypoint_info(:,1),"Waypoints",waypoint_info(:,2:4),...
"Orientation",quaternion(waypoint_info(:,5:end),'eulerd','ZYX','frame'));
p2 = platform(scene,'Trajectory',traj);


%% Visualize the pltforms using theatrePlot
tp = theaterPlot("XLimits",[-10e3 50e3],"YLimits",[-10e3 50e3],"ZLimits",[0 18e3],"AxesUnits",["km","km","km"]);
patch([-10e3 -10e3 50e3 50e3], [50e3 -10e3 -10e3 50e3],[0.8 0.8 0.8],'DisplayName','Enemy Territory')
patch([-10e3 -10e3 35e3 35e3], [35e3 -10e3 -10e3 35e3],[  0.7882 0.7333 0.7098],'DisplayName','Land')
% patch([-10e3 35e3 -10e3 35e3],'',[1 1 0.1],'DisplayName','Border')
view(45,45)

p1plot = platformPlotter(tp,"DisplayName",'ASR','Marker','^','MarkerFaceColor','b');    % platform creator
p2plot = platformPlotter(tp,"DisplayName",'Target','Marker','d','MarkerFaceColor','r'); 
p2traj = trajectoryPlotter(tp,"DisplayName",'Target Trajectory','Color',[0 0 0],'LineStyle',':','LineWidth',1);   % Trajectory plot creator
plotPlatform(p1plot,p1.Position,p1.Orientation)                                         % platform plotter
plotPlatform(p2plot,p2.Position,p2.Orientation)
plotTrajectory(p2traj,{p2.Trajectory.Waypoints})


% Creating coverage plotter and detection plotter for false and actual
% targets
cov = coveragePlotter(tp,"Alpha",[0.05 0.05],"DisplayName",'Radar beam');
truedetplot= detectionPlotter(tp,'Marker','o','DisplayName','True detection');
falsedetplot= detectionPlotter(tp,'Marker','x','MarkerFaceColor','r','DisplayName','False detections');
%% Assign the platforms with respective mounts

% Platform 1 is a monostatic radar with scanning options (Different
% scanning options and combinations will be tried out here)

% Electronic Scanning
radar = radarDataGenerator('UpdateRate',100,'SensorIndex',1,"CenterFrequency",3e9,"Bandwidth",200e6,"AzimuthResolution",1,"ElevationResolution",1, ...
    "DetectionMode","Monostatic",'FieldOfView',[10 110],'HasElevation',true,'ScanMode','Electronic','ElectronicAzimuthLimits',[0 90], ...
    'ElectronicElevationLimits',[-5 70]);

% % Mechanical scanning
% radar = radarDataGenerator(1,'UpdateRate',100,"CenterFrequency",3e9,"Bandwidth",200e6,"AzimuthResolution",1,"ElevationResolution",1, ...
%     "DetectionMode","Monostatic",'FieldOfView',[10 90],'HasElevation',true,'ScanMode','Mechanical','MechanicalAzimuthLimits',[0 90], ...
%     'MechanicalElevationLimits',[-5 70],'MaxAzimuthScanRate',400,'MaxElevationScanRate',6);
p1.Sensors = radar;

% Platform 2 


%% Simulate the scenario
restart(scene)
i = 1;
while advance(scene)
    det = detect(scene);
%     if isobject(det)
    detection{i} = det;
%     end
plotPlatform(p1plot,p1.Position,p1.Orientation)                                         % platform plotter
plotPlatform(p2plot,p2.Position,p2  .Orientation)

% Uncomment these for undeleted visualization of detections and beam
% scanning
% cov = coveragePlotter(tp,"Alpha",[0.05 0.05],"DisplayName",'Radar beam');
% truedetplot= detectionPlotter(tp,'Marker','o','DisplayName','True detection');
% falsedetplot= detectionPlotter(tp,'Marker','x','MarkerFaceColor','r','DisplayName','False detections');

plotTrajectory(p2traj,{p2.Trajectory.Waypoints})
plotCoverage(cov,coverageConfig(scene))

if ~isempty(detection{i})
    if detection{i}{1}.ObjectAttributes{:}.TargetIndex ==-1 
        plotDetection(falsedetplot,detection{i}{1}.Measurement.')
        if size(detection{i})>1
            if detection{i}{2}.ObjectAttributes{:}.TargetIndex ==-1
            plotDetection(falsedetplot,detection{i}{2}.Measurement.')
            end
        end
    end
    if detection{i}{1}.ObjectAttributes{:}.TargetIndex ~=-1 
    plotDetection(truedetplot,detection{i}{1}.Measurement.')
    end
end

i = i+1;
% drawnow

end
%% Extract Parameters
scan_det = detection(~cellfun("isempty",detection)); % Using logical masking
% in combination with cellfun to get the cells where target is detected.
false_tgt_ind = -1.*[1:4];
for i = 1:length(scan_det)
%     if size(scan_det{i},1)>=2
        for k = 1:length(scan_det{i})
            if scan_det{i}{k}.ObjectAttributes{:}.TargetIndex ~= -1.*false_tgt_ind;
                false_det(i) = scan_det{i}(k);
            elseif scan_det{i}{k}.ObjectAttributes{:}.TargetIndex ~= false_tgt_ind;
                true_det(i) = scan_det{i}(k);    
            end
        end
end




 % Verify all targets are false here (ind<0)
for i = 1:length(false_det)
    ind_f(i) = false_det{i}.ObjectAttributes{:}.TargetIndex;
end

% Verify all targets are true
for i = 1:length(true_det)
    if ~cellfun("isempty",true_det(i))
        ind_t(i) = true_det{i}.ObjectAttributes{:}.TargetIndex;
    end
end
