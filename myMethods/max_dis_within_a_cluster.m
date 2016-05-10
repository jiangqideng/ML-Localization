function T_dist = max_dis_within_a_cluster(fingerprint, initialRadioMap, T_rssChange, dist)
%根据指纹库计算一个参数，某个时刻被影响的链路中，相互之间最大的dist
    T_dist = 0;
    [m, n, len] = size(fingerprint);
    for i = 1 : m
        for j = 1 : n
            cur_rss = fingerprint(i, j, :);
            cur_rss = cur_rss(:);
            idx = find(abs(cur_rss - initialRadioMap) > T_rssChange);
            tmp(i, j) = max(max(dist(idx, idx)));
        end
    end
    T_dist = max(max(tmp));
end

