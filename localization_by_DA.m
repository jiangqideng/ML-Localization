function [err_da, classfication_Accuracy_da] = localization_by_DA( dataTrain, labelTrain, dataTest, labelTest, x_real_test, y_real_test)
%localization_by_naiveBayes
    model = ClassificationDiscriminant.fit(dataTrain, labelTrain);
    labelPredict = predict(model, dataTest);
    classfication_Accuracy_da = sum(labelPredict == labelTest) / length(labelTest);

    [x, y] = label2xy(labelPredict);
    err_da = mean(sqrt((x - x_real_test).^2 + (y - y_real_test).^2));
    fprintf('(discriminant analysis) Classfication_Accuracy: %f%%\n', classfication_Accuracy_da);
    fprintf('(discriminant analysis) Mean Localization error: %fm\n', err_da);
end

