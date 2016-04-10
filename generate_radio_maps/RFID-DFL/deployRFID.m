function [ readerPosition, tagPosition, links, linkDistance, readerNumbers, tagNumbers ] = deployRFID(roomLength, roomWidth)
%rfidDeployment: deploy RFID readers and tags
% set roomLength and roomWidth, which must be integer
    if nargin == 0
        roomLength = 20;
        roomWidth = 15;
    end
    if roomLength ~= fix(roomLength) || roomWidth ~= fix(roomWidth)
        disp('roomLength or roomWidth not integer');
        return;
    end
    readerPosition = [  
        -1                  roomWidth/2;
        roomLength + 1      roomWidth/2;
        roomLength/2        -1;
        roomLength/2        roomWidth + 1
        ];
    
    [X, Y] = meshgrid(0 : roomLength, 0 : roomWidth);
    tagPosition = [X(:), Y(:)];
    
    readerNumbers = size(readerPosition, 1);
    tagNumbers = size(tagPosition, 1);
    [a, b] = meshgrid(1:readerNumbers, 1:tagNumbers);
    links = [readerPosition(a(:), :), tagPosition(b(:), :)];
    linkDistance = sqrt((links(:, 1) - links(:, 3)).^2 + (links(:, 2) - links(:, 4)).^2);

end

