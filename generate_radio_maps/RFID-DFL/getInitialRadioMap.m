function [ initialRadioMap ] = getInitialRadioMap( roomLength, roomWidth, readerPosition, tagPosition, gridSize)
%getInitialRadioMap: get initial radio map with no object in the room
    if nargin == 4
        gridSize = 0.1;
    end
    if gridSize * 10 ~= fix( gridSize * 10 )
        disp('the gridSize better be 0.1 * n');
    end
    
    readerNumbers = size(readerPosition, 1);
    tagNumbers = size(tagPosition, 1);
    linkNumbers = readerNumbers * tagNumbers;
    initialRadioMap = zeros(roomLength / gridSize - 1, roomWidth / gridSize - 1, linkNumbers); %typically 199*149*linkNumbers

    [a, b] = meshgrid(1:readerNumbers, 1:tagNumbers);
    links = [readerPosition(a(:), :), tagPosition(b(:), :)];
    
    linkDistance = sqrt((links(:, 1) - links(:, 3)).^2 + (links(:, 2) - links(:, 4)).^2);
    attenuation = 20 * log(1 ./ linkDistance); %may be different in some different communication environment, but does not affect the final simulation results.
    tmp = repmat(attenuation', (roomLength / gridSize - 1) * (roomWidth / gridSize - 1), 1);
    initialRadioMap = reshape(tmp, roomLength / gridSize - 1, roomWidth / gridSize - 1, linkNumbers);
    
end

