clc;
clear;

addpath(genpath(pwd));
% load radioMap2--20m-15-6APm;
% load radioMap5--20m-15-20AP;
load DFL_radio_map;

noise = 2;
LN = 280;

fingerprint = fingerprint + normrnd(0, noise, size(fingerprint)); % add noise
m = size(fingerprint, 3);
for linksNumber = 1:LN
    tmp = 0;
    for times = 1:100
    
    idx = randperm(m);
    fp = fingerprint(:, :, idx(1:linksNumber));
    fprintf('linksNumber: %d\n', linksNumber);
    [ dataTrain, labelTrain, dataTest, labelTest, x_real_test, y_real_test ] = get_data_for_ML( fp, 10000);
    %knn
    [err_knn, classfication_Accuracy_knn] = localization_by_knn( dataTrain, labelTrain, dataTest, labelTest, x_real_test, y_real_test, 20 );
    %svm
%     [err_svm, classfication_Accuracy_svm] = localization_by_svm( dataTrain, labelTrain, dataTest, labelTest, x_real_test, y_real_test);
%     %random forest
%     [err_RF, classfication_Accuracy_RF] = localization_by_randomForest( dataTrain, labelTrain, dataTest, labelTest, x_real_test, y_real_test, 10 );
%     %naive bayes
%     [err_naiveBayes, classfication_Accuracy_naiveBayes] = localization_by_naiveBayes( dataTrain, labelTrain, dataTest, labelTest, x_real_test, y_real_test);
%     %discriminant analysis
%     [err_da, classfication_Accuracy_da] = localization_by_DA( dataTrain, labelTrain, dataTest, labelTest, x_real_test, y_real_test);
    
    tmp(times) = mean(err_knn);
    end
    knn_err_with_linksNumber(linksNumber) = mean(tmp);
end






