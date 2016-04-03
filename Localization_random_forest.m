%Localization Simulation Based on Random Forest

%% Data Preprocessing
load radioMap2--20m-15-6APm;
n = size(fingerprint, 3);%the number of APs
m = 20000;%the number of collected samples
[RSSMatrix, gridLabel, x_real, y_real] = fp_collection(fingerprint, n, m);
disp('data collection done.');
PCT = 0.7;%percentage
dataTrain = RSSMatrix(1 : ceil(PCT*m), :);
labelTrain = gridLabel(1 : ceil(PCT*m), :);
dataTest = RSSMatrix(ceil(PCT*m) + 1 : end, :);
labelTest = gridLabel(ceil(PCT*m) + 1 : end, :);

%% random forest (try ntrees = 1:50)
ntrees = 1; %try the decision tree, when ntrees = 1
model = TreeBagger(ntrees, dataTrain, labelTrain, 'fboot', 0.7, 'oobpred', 'on', 'nvartosample', 'all');

labelPredict = str2num(char(predict(model, dataTest)));
classfication_Accuracy(1) = sum(labelPredict == labelTest) / length(labelTest);
[x, y] = label2xy(labelPredict);
err(1) = mean(sqrt((x - x_real(ceil(PCT*m) + 1 : end)).^2 + (y - y_real(ceil(PCT*m) + 1 : end)).^2));
fprintf('(Decision Tree) Classfication_Accuracy: %f%%\n', classfication_Accuracy(1));
fprintf('(Decision Tree) Localization error: %fm\n', err(1));

for i = 2:10 %(ntrees = 50, running slowly? --> set a smaller value)
    model = growTrees(model, 1);
    labelPredict = str2num(char(predict(model, dataTest)));
    classfication_Accuracy(i) = sum(labelPredict == labelTest) / length(labelTest);
    [x, y] = label2xy(labelPredict);
    err(i) = mean(sqrt((x - x_real(ceil(PCT*m) + 1 : end)).^2 + (y - y_real(ceil(PCT*m) + 1 : end)).^2));
    fprintf('(Random Forest ntrees = %d) Localization error: %fm\n', i, err(i))
end

plot(oobError(model));
xlabel('number of grown trees');
ylabel('out-of-bag classification error');
figure;
plot(err);
xlabel('number of grown trees');
ylabel('Localization error');
figure;
plot(classfication_Accuracy);
xlabel('number of grown trees');
ylabel('Classfication accuracy');

%% random forest (ntrees = 50, runing slowly? --> set a smaller value)
ntrees = 10;
model = TreeBagger(ntrees, dataTrain, labelTrain, 'fboot', 0.7, 'oobpred', 'on', 'nvartosample', 'all');
labelPredict = str2num(char(predict(model, dataTest)));
classfication_Accuracy_50 = sum(labelPredict == labelTest) / length(labelTest);
[x, y] = label2xy(labelPredict);
err_50 = mean(sqrt((x - x_real(ceil(PCT*m) + 1 : end)).^2 + (y - y_real(ceil(PCT*m) + 1 : end)).^2));
fprintf('(Random Forest) Classfication_Accuracy: %f%%\n', classfication_Accuracy_50);
fprintf('(Random Forest) Localization error: %fm\n', err_50);

