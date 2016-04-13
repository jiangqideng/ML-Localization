function [err_RF, classfication_Accuracy_RF] = localization_by_randomForest( dataTrain, labelTrain, dataTest, labelTest, x_real_test, y_real_test, ntrees )
%localization_by_randomForest

    % random forest: setting a smaller ntrees can shorten the running time.
    model = TreeBagger(ntrees, dataTrain, labelTrain, 'fboot', 0.7, 'oobpred', 'on', 'nvartosample', 'all');
    labelPredict = str2num(char(predict(model, dataTest)));
    classfication_Accuracy_RF = sum(labelPredict == labelTest) / length(labelTest);
    [x, y] = label2xy(labelPredict);
    err_RF = sqrt((x - x_real_test).^2 + (y - y_real_test).^2);
    fprintf('(Random Forest) Classfication Accuracy: %f%%\n', classfication_Accuracy_RF);
    fprintf('(Random Forest) Mean Localization error: %fm\n', mean(err_RF));
end

