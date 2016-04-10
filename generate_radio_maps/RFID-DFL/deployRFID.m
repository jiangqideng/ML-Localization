function [ readerPosition, tagPosition ] = deployRFID(roomLength, roomWidth)
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
end

