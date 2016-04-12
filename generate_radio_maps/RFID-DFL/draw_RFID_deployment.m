function draw_RFID_deployment(roomLength, roomWidth)
%draw_RFID_deployment
    [ readerPosition, tagPosition, links, linkDistance, readerNumbers, tagNumbers ] = deployRFID(roomLength, roomWidth);

    scatter(readerPosition(:, 1), readerPosition(:, 2), 'pr'); 
    hold on; 
    axis([-2, roomLength + 2, -2, roomWidth + 2]);
    scatter(tagPosition(:, 1), tagPosition(:, 2), 'k.');
end

