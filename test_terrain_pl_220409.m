
for r = 1:sim.num_rx
    for k = 1:sim.num_tx
        if tx{k}.platformType == 2
            [lattx,lontx,~] = enu2geodetic(tx{k}.pos(1),tx{k}.pos(2),0,33.60811,73.10193,0,wgs84Ellipsoid);
            [latrx,lonrx,~] = enu2geodetic(rx{r}.pos(1),rx{r}.pos(2),0,33.60811,73.10193,0,wgs84Ellipsoid);
            ter(r,k) = terrain_pl(tx,sim,lattx,lontx,latrx,lonrx,k)
        end
    end
end
ter = db2mag(-1*ter)