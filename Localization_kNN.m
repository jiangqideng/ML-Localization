%Localization Simulation Based on kNN (Classification)
clc;
clear;
%% Data Preprocessing
load radioMap2--20m-15-6APm;
% load DFL_radio_map;
n = size(fingerprint, 3);%the number of APs
m = 20000;%the number of collected samples
[RSSMatrix, gridLabel, x_real, y_real] = fp_collection(fingerprint, n, m);
disp('data collection done.');
PCT = 0.7;%percentage
dataTrain = RSSMatrix(1 : ceil(PCT*m), :);
labelTrain = gridLabel(1 : ceil(PCT*m), :);
dataTest = RSSMatrix(ceil(PCT*m) + 1 : end, :);
labelTest = gridLabel(ceil(PCT*m) + 1 : end, :);

%% select an optimal k
% for k = 1:50%select an optimal k
%     model = ClassificationKNN.fit(dataTrain(1:ceil(PCT*length(dataTrain)), :),labelTrain(1:ceil(PCT*length(dataTrain))),'NumNeighbors',k);
%     labelPredict = predict(model, dataTrain(ceil(PCT*length(dataTrain)) + 1 : end, :));
%     accuracy(k) = sum( labelPredict == labelTrain(ceil(PCT*length(dataTrain)) + 1 : end) ) / length(labelPredict);
% end
% [~, k] = max(accuracy);
% fprintf('optimal k = %d\n', k);

%% kNN
k = 20;
model = ClassificationKNN.fit(dataTrain,labelTrain,'NumNeighbors',k);

labelPredict = predict(model, dataTest);
classfication_Accuracy = sum(labelPredict == labelTest) / length(labelTest);
[x, y] = label2xy(labelPredict);
err = mean(sqrt((x - x_real(ceil(PCT*m) + 1 : end)).^2 + (y - y_real(ceil(PCT*m) + 1 : end)).^2));
fprintf('(kNN) Classfication_Accuracy: %f%%\n', classfication_Accuracy);
fprintf('(kNN) Localization error: %fm\n', err);


