function radioMap = get_ezDFL_radio_map(roomLength, roomWidth, gridSize, attenuationFactor)
%get_ezDFL_radio_map: 
%simple DFL simmulation, add an attenuation constant for blocked links.

    % parameter check
    if nargin == 0
        roomLength = 20;
        roomWidth = 15;
        gridSize = 0.1;
        attenuationFactor = 20;
    end
    if roomLength ~= fix(roomLength) || roomWidth ~= fix(roomWidth)
        disp('roomLength or roomWidth not integer!');
        return;
    end
    if gridSize * 10 ~= fix( gridSize * 10 )
        disp('the gridSize better be 0.1 * n');
    end
    
    % deploy RFID
    [ readerPosition, tagPosition, links, linkDistance, readerNumbers, tagNumbers ] = deployRFID(roomLength, roomWidth);
    
    % get a initial radio map
    attenuation = 20 * log(1 ./ linkDistance); %may be different in some different communication environment, but does not affect the final simulation results.
    tmp = repmat(attenuation', (roomLength / gridSize - 1) * (roomWidth / gridSize - 1), 1);
    initialRadioMap = reshape(tmp, roomLength / gridSize - 1, roomWidth / gridSize - 1, size(links, 1));
    unfoldedRadioMap = initialRadioMap(:);
    
    %cheak blocked links
    [X, Y] = meshgrid(0.1 : 0.1 : roomLength - 0.1, 0.1 : 0.1 : roomWidth - 0.1);
    objectPosition = [X(:), Y(:)];
    opn = size(objectPosition, 1);
    ln = size(links, 1);
    [a, b] = meshgrid(1 : opn, 1 : ln);
    extObjectPosition = objectPosition(a(:), :);
    extLinks = links(b(:), :);
    extLinkDistance = sqrt((extLinks(:, 1) - extLinks(:, 3)).^2 + (extLinks(:, 2) - extLinks(:, 4)).^2);
    readerObjectTagDistance = sqrt((extObjectPosition(:, 1) - extLinks(:, 1)).^2 + (extObjectPosition(:, 2) - extLinks(:, 2)).^2) ...
        + sqrt((extObjectPosition(:, 1) - extLinks(:, 3)).^2 + (extObjectPosition(:, 2) - extLinks(:, 4)).^2);
    index = (readerObjectTagDistance < extLinkDistance + 2); %assume being blocked when a object in the ellipse
    
    % add an attenuation constant for those blocked links
    unfoldedRadioMap(index) = unfoldedRadioMap(index) - attenuationFactor;
    radioMap = reshape(unfoldedRadioMap, roomLength / gridSize - 1, roomWidth / gridSize - 1, size(links, 1));
end