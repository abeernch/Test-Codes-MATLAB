figure; hold on
while(1)
   xy = get(0,'PointerLocation');
   plot( xy(1), xy(2), 'Marker', '+' )
   drawnow
   pause( 0.1)
end