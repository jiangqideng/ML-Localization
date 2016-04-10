roomLength = 20;
roomWidth = 15;
gridSize = 0.1;
attenuationFactor = 20;
fingerprint = get_ezDFL_radio_map(roomLength, roomWidth, gridSize, attenuationFactor);
save('DFL_radio_map.mat', 'fingerprint');