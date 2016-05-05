roomLength = 20;
roomWidth = 15;
gridSize = 0.1;
attenuationFactor = 20;
ellipse_size = 0.1;

n_obj = 3;
t = 10000;

traces = getRandomTraces( roomLength, roomWidth, t, n_obj );

[initialRadioMap, index] = getRss_multi_obj_DFL_pre(roomLength, roomWidth, gridSize, attenuationFactor, ellipse_size);

rss = zeros(t, length(initialRadioMap));
gridLabel = zeros(t, n_obj);
for i = 1 : t
    positions = reshape(traces(i, :, :), 2, n_obj);
    rss(i, :) = getRss_multi_obj_DFL(n_obj, positions', initialRadioMap, index, attenuationFactor);
    for j = 1 : n_obj
        gridLabel(i, j) = xy2label(traces(i, 1, j), traces(i, 2, j));
    end
end

