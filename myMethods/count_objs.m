function n_obj_predict = count_objs(cur_rss, dist, initialRadioMap, T_rssChange)
% ���ݵ�ǰʱ�̵�rss������Ŀ��ĸ�����������dist�������ȼ�������ĸ���·֮���distance������ʼradio map������rss�������Ա仯����ֵ
    n_obj_predict = 0;
    
    idx = abs(cur_rss - initialRadioMap') > T_rssChange;
    linkIdx = find(idx == 1);
    c_links = dist(linkIdx, linkIdx);
    % ����
    Y_dist = f_squareform(c_links); %ת���ɺ���linkage��Ҫ����ʽ
    Z = linkage(Y_dist, 'average');
    tmp = Z(2:end) ./ Z(1:end-1);
    
    
%     [H,T] = dendrogram(Z,'colorthreshold','default');

    %��1��ʼ��,��������֮��ľ���ϴ���ô����������1�϶����㣬һֱ����ֱ��������������ʱ��ֹͣ��
    
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