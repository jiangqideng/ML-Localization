function [err_knn, classfication_Accuracy_knn] = localization_by_knn( dataTrain, labelTrain, dataTest, labelTest, x_real_test, y_real_test, k )
%localization_by_knn
    if nargin < 7
        % select an optimal k
        PCT = 0.7;
        for k = 1:50
            model = ClassificationKNN.fit(dataTrain(1:ceil(PCT*length(dataTrain)), :),labelTrain(1:ceil(PCT*length(dataTrain))),'NumNeighbors',k);
            labelPredict = predict(model, dataTrain(ceil(PCT*length(dataTrain)) + 1 : end, :));
            accuracy(k) = sum( labelPredict == labelTrain(ceil(PCT*length(dataTrain)) + 1 : end) ) / length(labelPredict);
        end
        [~, k] = max(accuracy);
        fprintf('optimal k = %d\n', k);
    end
    
    model = ClassificationKNN.fit(dataTrain,labelTrain,'NumNeighbors',k);
    labelPredict = predict(model, dataTest);
    classfication_Accuracy_knn = sum(labelPredict == labelTest) / length(labelTest);
    [x, y] = label2xy(labelPredict);
    err_knn = sqrt((x - x_real_test).^2 + (y - y_real_test).^2);
%     fprintf('(kNN) Classfication Accuracy: %f%%\n', classfication_Accuracy_knn);
%     fprintf('(kNN) Mean Localization error: %fm\n', mean(err_knn));
end

