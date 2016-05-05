clc;
clear;
%if out of memory, change the parameters: 'ellipse_size' --> [0.2 0.5 1],
%or go to deployRFID.m and reduce the number of Tags.

roomLength = 20;
roomWidth = 15;
gridSize = 0.1;
attenuationFactor = 20;
ellipse_size = 0.1;

[initialRadioMap, index] = getRss_multi_obj_DFL_pre(roomLength, roomWidth, gridSize, attenuationFactor, ellipse_size);

n_obj = 2;
positions = [15.5, 2.5; 10, 12.5];
rss = getRss_multi_obj_DFL(n_obj, positions, initialRadioMap, index, attenuationFactor);





draw_RFID_deployment(roomLength, roomWidth);hold on;
idx = (rss ~= initialRadioMap);
[ readerPosition, tagPosition, links, linkDistance, readerNumbers, tagNumbers ] = deployRFID(roomLength, roomWidth);blockedLinks = links(idx(:), :);
for i = 1 : size(blockedLinks)
    plot(blockedLinks(i, [1 3]), blockedLinks(i, [2 4]), 'c'); 
end
scatter(positions(:, 1), positions(:, 2))

