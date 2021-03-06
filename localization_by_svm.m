function [err_svm, classfication_Accuracy_svm] = localization_by_svm( dataTrain, labelTrain, dataTest, labelTest, x_real_test, y_real_test, ...
    auto_parameters, s, t, c, g)
%localization_by_svm

    %data scaling
    scale = 2 /(max(max(dataTrain)) - min(min(dataTrain)));
    bias = mean(mean(dataTrain));
    dataTrain = (dataTrain - bias) * scale; 
    dataTest = (dataTest - bias) * scale; 

    %svm parameters
    if nargin == 6
        s = 0;
        t = 2;
        c = 100;
        g = 2;
    elseif auto_parameters == 1
        % parameter selection by cross validation
        s = 0;   % C-SVC
        t = 2;   % radial basis function
        speed_up = 5000;
        if size(dataTrain, 1) > speed_up %speed up
            dataTrain_s = dataTrain(1:speed_up, :);
            labelTrain_s = labelTrain(1:speed_up, :);
        end
        for ci = 1:5:30
            c = 2^(ci - 15); % c: [2^-14, 2^15]
            fprintf('c: = %f\n', c);
            for gi = 1:5:30
                g = 2^(gi - 15); % g: [2^-14, 2^15]
                fprintf('g: = %f\n', g);
                svmpara = ['-s ' num2str(s) ' -t ' num2str(t) ' -c ' num2str(c) ' -g ' num2str(g) ' -q' ' -v 5'];
                cv(ci, gi) = svmtrain(labelTrain_s, dataTrain_s, svmpara);
            end
        end
        [ci_optimal, gi_optimal] = find(cv == max(max(cv)));
        c = 2^(ci_optimal(1) - 15);
        g = 2^(gi_optimal(1) - 15);
        fprintf('optimal c: %f    optimal g: %f\n', c, g)
    end
    
    %localization, use the svm toolkit 'LIBSVM'
    svmpara = ['-s ' num2str(s) ' -t ' num2str(t) ' -c ' num2str(c) ' -g ' num2str(g) ' -q'];
    model = svmtrain(labelTrain, dataTrain, svmpara);
    [labelPredict, classfication_Accuracy_svm, ~] = svmpredict(labelTest, dataTest, model);

    [x, y] = label2xy(labelPredict);
    err_svm = sqrt((x - x_real_test).^2 + (y - y_real_test).^2);
    fprintf('(svm) Classfication Accuracy: %f%%\n', classfication_Accuracy_svm(1));
    fprintf('(svm) Mean Localization error: %fm\n', mean(err_svm));
    
end

