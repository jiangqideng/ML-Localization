clc;
clear;

addpath(genpath(pwd));
load DFL_radio_map;
load initial_DFL_radio_map;
noise = 2;
fingerprint = fingerprint + normrnd(0, noise, size(fingerprint)); % add noise
m = size(fingerprint, 3);

[ dataTrain, labelTrain] = get_data_for_ML( fingerprint, 10000 );

%% test single object
% load testData-1; %traces, rss, grilLabel
% rss = rss(1:1000, :);
% traces = traces(1:1000, :);
% gridLabel = gridLabel(1:1000);
% 
% Thr = 10;
% t = size(rss, 1);
% for i = 1 : t
%     cur_rss = rss(i, :);
%     idx = abs(cur_rss - initialRadioMap') > Thr;
%     %only use changed links to train: mean error = 0.6991m    和椭圆大小有关系呀
%     k = 20;
%     model = ClassificationKNN.fit(dataTrain(:, idx),labelTrain,'NumNeighbors',k);
%     labelPredict(i) = predict(model, cur_rss(idx));
%     if rem(i, 100) == 0
%         disp(i);
%         disp(sum(idx));
%     end
% end
% 
% classfication_Accuracy_knn = sum(labelPredict == gridLabel') / length(gridLabel);
% [x, y] = label2xy(labelPredict);
% err_knn = sqrt((x' - traces(:, 1)).^2 + (y' - traces(:, 2)).^2);
% disp(mean(err_knn));

%% test two objects
T_rssChange = 10;
dist = cal_linksDistance(fingerprint, initialRadioMap, T_rssChange);

load testData-2; %traces, rss, grilLabel
rss = rss(1:1000, :);
traces = traces(1:1000, :, 1);
gridLabel = gridLabel(1:1000, 1);

t = size(rss, 1);
for i = 1 : t
    cur_rss = rss(i, :);
    idx = abs(cur_rss - initialRadioMap') > T_rssChange;
    linkIdx = find(idx == 1);
    c_links = dist(linkIdx, linkIdx);
    Y_dist = f_squareform(c_links);
    Z = linkage(Y_dist, 'average');
%     [H,T] = dendrogram(Z,'colorthreshold','default');
    T = cluster(Z,'maxclust',2);
    idx1 = linkIdx(T == 1);
    idx2 = linkIdx(T == 2);
    
    
    idx = idx1;
    
    
    k = 20;
    model = ClassificationKNN.fit(dataTrain(:, idx),labelTrain,'NumNeighbors',k);
    labelPredict(i) = predict(model, cur_rss(idx));
    if rem(i, 10) == 0
        disp(i);
        disp(sum(idx));
    end
end

return;

classfication_Accuracy_knn = sum(labelPredict == gridLabel') / length(gridLabel);
[x, y] = label2xy(labelPredict);
err_knn = sqrt((x' - traces(:, 1)).^2 + (y' - traces(:, 2)).^2);
disp(mean(err_knn));


