function n_obj_predict = count_objs(cur_rss, dist, initialRadioMap, T_rssChange)
% 根据当前时刻的rss，估计目标的个数。利用了dist矩阵（事先计算出来的各链路之间的distance）、初始radio map、代表rss发生明显变化的阈值
    n_obj_predict = 0;
    
    idx = abs(cur_rss - initialRadioMap') > T_rssChange;
    linkIdx = find(idx == 1);
    c_links = dist(linkIdx, linkIdx);
    % 聚类
    Y_dist = f_squareform(c_links); %转换成函数linkage需要的形式
    Z = linkage(Y_dist, 'average');
    tmp = Z(2:end) ./ Z(1:end-1);
    
    
%     [H,T] = dendrogram(Z,'colorthreshold','default');

    %从1开始猜,如果簇与簇之间的距离较大，那么满足条件，1肯定满足，一直往后，直到不满足条件的时候停止。
    
    c = 0.5;
    for i = 1 : max_objs
        T = cluster(Z,'cutoff',c,'criterion','distance');
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%2016.5.10%%%%
    
%     T_dist = 0.7;
%     for i = 1 : max_objs
%         T = cluster(Z,'maxclust', i);
%         flag = 1;
%         n = max(T);
%         for j = 1 : n
%             a_cluster_idx = linkIdx(T == j);
%             tmp = dist(a_cluster_idx, a_cluster_idx);
%             if max(tmp(:)) > T_dist
%                 flag = 0;
%                 break;
%             end
%         end
%         if flag == 1
%             n_obj_predict = i;
%             return;
%         end
%     end
end