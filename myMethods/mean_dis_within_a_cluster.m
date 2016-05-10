function T_dist = mean_dis_within_a_cluster(fingerprint, initialRadioMap, T_rssChange, dist)
%根据指纹库计算一个参数，某个时刻被影响的链路中，平均的dist
    T_dist = 0;
    [m, n, len] = size(fingerprint);
    for i = 1 : m
        for j = 1 : n
            cur_rss = fingerprint(i, j, :);
            cur_rss = cur_rss(:);
            idx = find(abs(cur_rss - initialRadioMap) > T_rssChange);
            tmp(i, j) = mean(mean(dist(idx, idx)));
        end
    end
    T_dist = mean(tmp(:));
end

