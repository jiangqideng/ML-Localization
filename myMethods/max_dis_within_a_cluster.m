function T_dist = max_dis_within_a_cluster(fingerprint, initialRadioMap, T_rssChange, dist)
%����ָ�ƿ����һ��������ĳ��ʱ�̱�Ӱ�����·�У��໥֮������dist
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

