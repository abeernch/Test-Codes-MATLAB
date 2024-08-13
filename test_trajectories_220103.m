%Testing Radar Scenario with different functions, platform behaviour
% and set properties.

% A simulation where a mechanically scanned, stationary air-surveillance
% radar scans the volume. It encounters two aircrafts, each with an
% airborne radar that is electronically scanned. Trajectories of the two
% aircraft are defined alongwith other radar parameters.
clear;clc;close all

%% Create the radar scenario
scene = radarScenario();
scene.StopTime = 100;
% scene.SimulationTime = 10;
scene.UpdateRate = 10;

%% Create the scenario platforms

% ASR ( A static platform with defined orientation)
asr_pf = platform(scene,'Position',[5 5 0],'Orientation',[[0 1 0];[0 0 0 ];[0 0 0 ]]);

% Aircraft 1 (A moving platform with a defined motion)
% ac1_pf = platform(scene);

 ac1_motion =     [0,   0,0,0,    0,0,0; ... % Initial position
                  0.1, 0,0.1,0,  0,0,0; ...

                  0.9, 0,0.9,0,  0,0,0; ...
                  1,   0,1,0,    45,0,0; ...
                  1.1, 0.1,1,-2,  90,0,0; ...

                  1.9, 0.9,1,0,  90,0,0; ...
                  2,   1,1,0,    135,0,0; ...
                  2.1, 1,0.9,0,  180,0,0; ...

                  2.9, 1,0.1,0,  180,0,0; ...
                  3,   1,0,0,    225,0,0; ...
                  3.1, 0.9,0,2,  270,0,0; ...

                  3.9, 0.1,0,0,  270,0,10; ...
                  4,   0,0,0,    270,0,10];
ac1_pftraj = waypointTrajectory('SampleRate',1e3,'Waypoints',ac1_motion(:,2:4),"Orientation",quaternion(ac1_motion(:,5:end),'eulerd','ZYX','frame'),"TimeOfArrival",ac1_motion(:,1));
count = 1;
% while ~isDone(ac1_pftraj)
% 
%     [pos(count,:),orientation(count), vel(count,:),acc(count,:) ] = ac1_pftraj();
%     count = count + 1;
% 
% end
% 
% axis([-1 2 -1 2 -2 2])
% view(45,45)
% l = animatedline;
% for i = 1:count-1
%    
%     addpoints(l,pos(i,1),pos(i,2),pos(i,3))
%      drawnow
% end
% 
% 
% eulerAngles = eulerd([orientation],'ZYX','frame');
% t = 0:0.001:4-0.001;
% plot(t,eulerAngles(:,1),'ko', ...
%                    t,eulerAngles(:,2),'bd', ...
%                    t,eulerAngles(:,3),'r.');
% % plot3(pos(:,1),pos(:,2),pos(:,3))
%% Aircraft 2 
ac2_pf = platform(scene);

% define the kinematics of the 
fs2 =1e3;
r2 = 20;
speed2 = 300;
initialYaw2 = 150;
initPos2 = [r2*3 r2 2*r2];
initVel2 = [speed2 0 speed2/2];
initOrient2 = quaternion([initialYaw2 0 45], 'eulerd', 'ZYX', 'frame');

accBody2 = [0 speed2^2/r2 0];
angVelBody2 = [0 speed2/r2 0 ];

ac2_pftraj = kinematicTrajectory('SampleRate',fs2,'Orientation',initOrient2, ...
 'Position',initPos2,'Velocity',initVel2,'Acceleration',accBody2,'AngularVelocity',angVelBody2,'AccelerationSource','Property','AngularVelocitySource','Property');

% Visualizing the trajectory of the A/C
for i = 1:fs2
    ac2_pos(:,i) = ac2_pftraj();
end

%% Plotting the platform using theatrePlot

tp = theaterPlot("XLimits",[-10 50],"YLimits",[-10 50],"ZLimits",[0 20]);
view(45,45)
patch([-10 50 50 -10],[50 50 -10 -10],[0.902 0.902 0.902],'DisplayName','Volume')
p1plot = platformPlotter(tp,"DisplayName",'ASR','Marker','^','MarkerFaceColor',[1.0000 1.0000 0.0667]);
p2plot = platformPlotter(tp,"DisplayName",'A/C - 1','Marker','d','MarkerFaceColor','r');
p3plot = platformPlotter(tp,"DisplayName",'A/C - 2','Marker','d','MarkerFaceColor','b');

while advance(scene)
    plotPlatform(p1plot,asr_pf.Position,asr_pf.Orientation,{'ASR'})
    plotPlatform(p2plot,ac1_pftraj(),{'A/C - 1'})
    plotPlatform(p3plot,ac2_pf.Position,ac2_pftraj(),{'A/C - 2'})
end