function dist = cal_linksDistance(fingerprint, initialRadioMap, T_rssChange)
% calculate the correlation between links, as distances
    [m, n, len] = size(fingerprint);
    dist = zeros(len, len);
    for i = 1 : m
        for j = 1 : n
            cur_rss = fingerprint(i, j, :);
            cur_rss = cur_rss(:);
            idx = find(abs(cur_rss - initialRadioMap) > T_rssChange);
            dist(idx, idx) = dist(idx, idx) + 1;
        end
    end

    dist = 1 ./ (dist + 1);
%     dist = -dist + max(max(dist));
end