cdata = flipdim( imread('sky.jpg'), 1 );
cdatar = (flipdim( cdata, 2 ));

% % bottom
% surface([-1 1; -1 1], [-1 -1; 1 1], [-1 -1; -1 -1], ...
%     'FaceColor', 'texturemap', 'CData', cdatar );
% % top
% surface([-1 1; -1 1], [-1 -1; 1 1], [1 1; 1 1], ...
%     'FaceColor', 'texturemap', 'CData', cdata );

% % font
% surface([-1 1; -1 1], [-1 -1; -1 -1], [-1 -1; 1 1], ...
%     'FaceColor', 'texturemap', 'CData', cdata );
% back
surface([1 1; 12534 12534], [1 1; 1 1], [1 35; 1 35], ...
    'FaceColor', 'texturemap', 'CData', pagectranspose(cdata),'FaceAlpha',0.1,'EdgeAlpha',0  );

% left
surface([1 1; 1 1], [1 1; 9216 9216], [1 35; 1 35], ...
    'FaceColor', 'texturemap', 'CData', pagectranspose(cdata),'FaceAlpha',0.1,'EdgeAlpha',0);
% right
% surface([1 1; 1 1], [-1 1; -1 1], [-1 -1; 1 1], ...
%     'FaceColor', 'texturemap', 'CData', cdatar,'FaceAlpha',0.1,'EdgeAlpha',0);

% view(3);