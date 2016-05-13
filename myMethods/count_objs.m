function [n_obj_predict, obj_link_idx] = count_objs(cur_rss, dist, initialRadioMap, T_rssChange, n_obj_pre)
% 根据当前时刻的rss，估计目标的个数。利用了dist矩阵（事先计算出来的各链路之间的distance）、初始radio map、代表rss发生明显变化的阈值
% 预测目标个数之后，给出受各目标影响的链路
    n_obj_predict = 0;
    obj_link_idx = {};
    
    idx = abs(cur_rss - initialRadioMap') > T_rssChange;
    linkIdx = find(idx == 1);
    c_links = dist(linkIdx, linkIdx);
    % 聚类
    Y_dist = f_squareform(c_links); %转换成函数linkage需要的形式
    Z = linkage(Y_dist, 'average');
    tmp = Z(2:end) ./ Z(1:end-1);
%     [H,T] = dendrogram(Z,'colorthreshold','default');

%     c = 0.01;
%     T = cluster(Z,'cutoff',c,'criterion','distance');
%     n_obj_predict = max(T); %先简单预测一下，以后要结合时间前后信息来准确预测
    
    n_obj_predict = n_obj_pre;
    T = cluster(Z,'maxclust',n_obj_predict);
    
    for i = 1 : n_obj_predict
        obj_link_idx{i} = linkIdx(T == i);
    end

end