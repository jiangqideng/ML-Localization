function T_links = maxLinks_within_a_cluster(fingerprint, initialRadioMap, T_rssChange)
%����ָ�ƿ����һ��������ĳ��ʱ�̱�Ӱ�����·�У��໥֮������dist
    T_links = 0;
    [m, n, len] = size(fingerprint);
    for i = 1 : m
        for j = 1 : n
            cur_rss = fingerprint(i, j, :);
            cur_rss = cur_rss(:);
            tmp(i, j) = sum(abs(cur_rss - initialRadioMap) > T_rssChange);
        end
    end
    T_links = max(max(tmp));
end

