%Localization Simulation Based on Naive Bayes (Classification)
clc;
clear;
%% Data Preprocessing
% load radioMap2--20m-15-6APm;
load DFL_radio_map;
fingerprint = fingerprint + normrnd(0, 3, size(fingerprint)); % add noise
n = size(fingerprint, 3);%the number of APs
m = 20000;%the number of collected samples
[RSSMatrix, gridLabel, x_real, y_real] = fp_collection(fingerprint, n, m);
disp('data collection done.');
PCT = 0.7;%percentage
dataTrain = RSSMatrix(1 : ceil(PCT*m), :);
labelTrain = gridLabel(1 : ceil(PCT*m), :);
dataTest = RSSMatrix(ceil(PCT*m) + 1 : end, :);
labelTest = gridLabel(ceil(PCT*m) + 1 : end, :);

%% naive Bayes
model = NaiveBayes.fit(dataTrain,labelTrain);
labelPredict = predict(model, dataTest);
classfication_Accuracy = sum(labelPredict == labelTest) / length(labelTest);

[x, y] = label2xy(labelPredict);
err = mean(sqrt((x - x_real(ceil(PCT*m) + 1 : end)).^2 + (y - y_real(ceil(PCT*m) + 1 : end)).^2));
fprintf('(Naive Bayes) Classfication_Accuracy: %f%%\n', classfication_Accuracy);
fprintf('(Naive Bayes) Localization error: %fm\n', err);


