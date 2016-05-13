function [n_obj_predict, obj_link_idx] = count_objs(cur_rss, dist, initialRadioMap, T_rssChange, n_obj_pre)
% ���ݵ�ǰʱ�̵�rss������Ŀ��ĸ�����������dist�������ȼ�������ĸ���·֮���distance������ʼradio map������rss�������Ա仯����ֵ
% Ԥ��Ŀ�����֮�󣬸����ܸ�Ŀ��Ӱ�����·
    n_obj_predict = 0;
    obj_link_idx = {};
    
    idx = abs(cur_rss - initialRadioMap') > T_rssChange;
    linkIdx = find(idx == 1);
    c_links = dist(linkIdx, linkIdx);
    % ����
    Y_dist = f_squareform(c_links); %ת���ɺ���linkage��Ҫ����ʽ
    Z = linkage(Y_dist, 'average');
    tmp = Z(2:end) ./ Z(1:end-1);
%     [H,T] = dendrogram(Z,'colorthreshold','default');

%     c = 0.01;
%     T = cluster(Z,'cutoff',c,'criterion','distance');
%     n_obj_predict = max(T); %�ȼ�Ԥ��һ�£��Ժ�Ҫ���ʱ��ǰ����Ϣ��׼ȷԤ��
    
    n_obj_predict = n_obj_pre;
    T = cluster(Z,'maxclust',n_obj_predict);
    
    for i = 1 : n_obj_predict
        obj_link_idx{i} = linkIdx(T == i);
    end

end