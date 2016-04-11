clc;
clear;
%if out of memory, change the parameters: 'ellipse_size' --> [0.2 0.5 1],
%or go to deployRFID.m and reduce the number of Tags.

roomLength = 20;
roomWidth = 15;
gridSize = 0.1;
attenuationFactor = 20;
ellipse_size = 1;
fingerprint = get_ezDFL_radio_map(roomLength, roomWidth, gridSize, attenuationFactor, ellipse_size);
save('DFL_radio_map.mat', 'fingerprint');