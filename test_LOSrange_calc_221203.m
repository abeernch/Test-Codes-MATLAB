%% Script for Line-of-sight (LOS) calculation for ELINT SG

% Based on the heights of the respective interacting platforms in a created
% scenario, the LOS range will be calculated. If the slant range is less
% than or equal to the calculated LOS range, signals will be received with
% appropriate attenuation as per the FSPL and/or Atmospheric attenuation
% model. The LOS range calculation and inhibition of reception of signals
% will be disabled for the case when terrain loss is enabled.


% Author: Abeer Nasir Chaudhry®

tx_pos_z = 3.281*30;
rx_pos_z = 3.281*18;
R = 6400e3;


range_los = sqrt(2*R*tx_pos_z) + sqrt(2*R*rx_pos_z);
