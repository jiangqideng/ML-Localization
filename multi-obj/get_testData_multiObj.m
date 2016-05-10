function [traces, rss, gridLabel] = get_testData_multiObj(n_obj, t)
% 设置多个目标，在房间中随机游走，记录t个时刻的数据，包含每个时刻的位置坐标（traces），以及相应的RSS、gridLabel
    roomLength = 20;
    roomWidth = 15;
    gridSize = 0.1;
    attenuationFactor = 20;
    ellipse_size = 1;
    % n_obj = 1;
    % t = 10000;
    
    %下面调用的各个函数也许出现在上个目录的各子目录中，在matlab里可以在本函数的上个目录下添加所有子目录，然后运行，就能调用到这些函数了
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
end

