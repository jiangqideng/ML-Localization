
% clc;
% clear;
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

% n_obj = 3;
t = 100;
[traces, rss, gridLabel] = get_testData_multiObj(n_obj, t);

traces_ = zeros(size(traces));
gridLabel_ = zeros(size(gridLabel));

for i = 1 : t
    cur_rss = rss(i, :);
    n_obj_pre = n_obj; %先假设个数预测准确正确
    [n_obj_predict, obj_link_idx] = count_objs(cur_rss, dist, initialRadioMap, T_rssChange, n_obj_pre);

%     [n_obj_predict, obj_link_idx] = links_reduction(n_obj_predict, obj_link_idx, dist);
    
    for j = 1 : n_obj_predict
        idx = obj_link_idx{j};
        k = 5;
        model = ClassificationKNN.fit(dataTrain(:, idx),labelTrain,'NumNeighbors',k);
        gridLabel_(i, j) = predict(model, cur_rss(idx));
    end
end

%calculate error

[err, traces_] = cal_multi_obj_err(gridLabel_, traces);
fprintf('n_objs = %d, mean error = %f\n', n_obj, mean(err));


