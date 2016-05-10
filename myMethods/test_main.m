
clc;
clear;
load DFL_radio_map;
load initial_DFL_radio_map;

noise = 2;
fingerprint = fingerprint + normrnd(0, noise, size(fingerprint)); % add noise
m = size(fingerprint, 3);

[ dataTrain, labelTrain] = get_data_for_ML( fingerprint, 10000 );

% cal_linksDistance
T_rssChange = 10;
dist = cal_linksDistance(fingerprint, initialRadioMap, T_rssChange);

T_dist = max_dis_within_a_cluster(fingerprint, initialRadioMap, T_rssChange, dist); %T_dist = 0.5;
% T_dist = mean_dis_within_a_cluster(fingerprint, initialRadioMap, T_rssChange); 
T_links = maxLinks_within_a_cluster(fingerprint, initialRadioMap, T_rssChange);%最多能影响多少条链路

n_obj = 5;
t = 1000;
[traces, rss, gridLabel] = get_testData_multiObj(n_obj, t);

for i = 1 : t
    cur_rss = rss(i, :);
    n_obj_predict = count_objs(cur_rss, dist, initialRadioMap, T_rssChange);


% % 
% % for i = 1 : t
% %     cur_rss = rss(i, :);
% %     idx = abs(cur_rss - initialRadioMap') > T_rssChange;
% %     linkIdx = find(idx == 1);
% %     c_links = dist(linkIdx, linkIdx);
% %     Y_dist = f_squareform(c_links);
% %     Z = linkage(Y_dist, 'average');
% %     [H,T] = dendrogram(Z,'colorthreshold','default');
% %     T = cluster(Z,'maxclust',2);
% %     idx1 = linkIdx(T == 1);
% %     idx2 = linkIdx(T == 2);
% %     
% %     
% %     idx = idx1;
% %     
% %     
% %     k = 20;
% %     model = ClassificationKNN.fit(dataTrain(:, idx),labelTrain,'NumNeighbors',k);
% %     labelPredict(i) = predict(model, cur_rss(idx));
% %     if rem(i, 10) == 0
% %         disp(i);
% %         disp(sum(idx));
% %     end
% % end
% % 
% % return;
% % 
% % classfication_Accuracy_knn = sum(labelPredict == gridLabel') / length(gridLabel);
% % [x, y] = label2xy(labelPredict);
% % err_knn = sqrt((x' - traces(:, 1)).^2 + (y' - traces(:, 2)).^2);
% % disp(mean(err_knn));
% % 
% % 
