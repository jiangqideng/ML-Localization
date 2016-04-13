%Localization Simulation Based on svm (Classification)
%use the 'libsvm' (preinstall)
clc;
clear;
%% Data Preprocessing
load radioMap2--20m-15-6APm;
n = size(fingerprint, 3);%the number of APs
m = 20000;%the number of collected samples
[RSSMatrix, gridLabel, x_real, y_real] = fp_collection(fingerprint, n, m);
disp('data collection done.');
PCT = 0.7;%percentage
scale = 2 /(max(max(RSSMatrix)) - min(min(RSSMatrix)));
bias = mean(mean(RSSMatrix));
RSSMatrix = (RSSMatrix - bias) * scale; %data scaling
dataTrain = RSSMatrix(1 : ceil(PCT*m), :);
labelTrain = gridLabel(1 : ceil(PCT*m), :);
dataTest = RSSMatrix(ceil(PCT*m) + 1 : end, :);
labelTest = gridLabel(ceil(PCT*m) + 1 : end, :);

%% parameter testing by cross validation

% s = 0;   % C-SVC
% t = 2;   % radial basis function
% for ci = 1:30
%     c = 2^(ci - 15); % c: [2^-14, 2^15]
%     fprintf('c: = %f\n', c);
%     for gi = 1:30
%         g = 2^(gi - 15); % g: [2^-14, 2^15]
%         fprintf('g: = %f\n', g);
%         svmpara = ['-s ' num2str(s) ' -t ' num2str(t) ' -c ' num2str(c) ' -g ' num2str(g) ' -q' ' -v 5'];
%         cv(ci, gi) = svmtrain(labelTrain, dataTrain, svmpara);
%     end
% end

%% tran, predict, accuracy
s = 0;
t = 2;
% [ci_optimal, gi_optimal] = find(cv == max(max(cv)));
% c = 2^(ci_optimal - 15);
% g = 2^(gi_optimal - 15);
c = 1000;
g = 2;
svmpara = ['-s ' num2str(s) ' -t ' num2str(t) ' -c ' num2str(c) ' -g ' num2str(g) ' -q'];
model = svmtrain(labelTrain, dataTrain, svmpara);
[labelPredict, classfication_Accuracy, ~] = svmpredict(labelTest, dataTest, model);

[x, y] = label2xy(labelPredict);
err = mean(sqrt((x - x_real(ceil(PCT*m) + 1 : end)).^2 + (y - y_real(ceil(PCT*m) + 1 : end)).^2));
fprintf('(svm) Classfication_Accuracy: %f%%\n', classfication_Accuracy(1));
fprintf('(svm) Localization error: %fm\n', err);



