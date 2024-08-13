%% Test Code for determining distance between to points in LAT,LON using the great circle formula

[lat1,lon1] = deal(33.609045224868254,73.10409938026896);
[lat2,lon2] = deal(33.543838576497635,73.13794522062958);

% Distance Between two points in [lat,lon]
d = deg2km(2*asind(sqrt((sind((lat1-lat2)/2))^2 + cosd(lat1)*cosd(lat2)*(sind((lon1-lon2)/2))^2)))*1e3;
rangeDelay = d./3e8;