function [err_naiveBayes, classfication_Accuracy_naiveBayes] = localization_by_naiveBayes( dataTrain, labelTrain, dataTest, labelTest, x_real_test, y_real_test)
%localization_by_naiveBayes
    model = NaiveBayes.fit(dataTrain,labelTrain);
    labelPredict = predict(model, dataTest);
    classfication_Accuracy_naiveBayes = sum(labelPredict == labelTest) / length(labelTest);

    [x, y] = label2xy(labelPredict);
    err_naiveBayes = mean(sqrt((x - x_real_test).^2 + (y - y_real_test).^2));
    fprintf('(Naive Bayes) Classfication_Accuracy: %f%%\n', classfication_Accuracy_naiveBayes);
    fprintf('(Naive Bayes) Mean Localization error: %fm\n', err_naiveBayes);

    
end

