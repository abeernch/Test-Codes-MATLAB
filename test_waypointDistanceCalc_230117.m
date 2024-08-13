% Calculate total distance from waypoints
for i = 2:length(tx{1}.trajPos)
    wp1 = tx{1}.trajPos(:,i-1).';
    wp2 = tx{1}.trajPos(:,i).';
    dist(i) = norm(wp2 - wp1);
end
cum_dist = sum(dist)
