function rss = getRss_multi_obj_DFL(n_obj, positions, initialRadioMap, index, attenuationFactor)
    rss = initialRadioMap;
    for i = 1 : n_obj
        x = ceil(positions(i, 1) * 10);
        y = ceil(positions(i, 2) * 10);
        idx = index(x, y, :);
        idx = idx(:);
        rss = rss - attenuationFactor * idx;
    end
end