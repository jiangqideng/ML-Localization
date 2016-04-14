clc;
clear;

addpath(genpath(pwd));
% load radioMap2--20m-15-6APm;
load DFL_radio_map;

noise = 3;
LN = 1000;

fingerprint = fingerprint + normrnd(0, 3, size(fingerprint)); % add noise
m = size(fingerprint, 3);
for linksNumber = LN
    idx = randperm(m);
    fp = fingerprint(:, :, idx(1:linksNumber));
    fprintf('linksNumber: %d', linksNumber);
    [ dataTrain, labelTrain, dataTest, labelTest, x_real_test, y_real_test ] = get_data_for_ML( fp, 10000);
    %knn
    [err_knn, classfication_Accuracy_knn] = localization_by_knn( dataTrain, labelTrain, dataTest, labelTest, x_real_test, y_real_test, 20 );
    %svm
    [err_svm, classfication_Accuracy_svm] = localization_by_svm( dataTrain, labelTrain, dataTest, labelTest, x_real_test, y_real_test);
    %random forest
    [err_knn, classfication_Accuracy_RF] = localization_by_randomForest( dataTrain, labelTrain, dataTest, labelTest, x_real_test, y_real_test, 50 );
end






