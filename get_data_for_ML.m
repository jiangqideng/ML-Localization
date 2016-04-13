function [ dataTrain, labelTrain, dataTest, labelTest, x_real_test, y_real_test ] = get_data_for_ML( radioMap )
%get_data_for_ML: 
%get data from a radio map, preparing for localization test.
    n = size(radioMap, 3);%number of APs
    m = 20000;%number of collected samples
    [RSSMatrix, gridLabel, x_real, y_real] = fp_collection(radioMap, n, m);
    PCT = 0.7;%percentage
    scale = 2 /(max(max(RSSMatrix)) - min(min(RSSMatrix)));
    bias = mean(mean(RSSMatrix));
    RSSMatrix = (RSSMatrix - bias) * scale; %data scaling
    dataTrain = RSSMatrix(1 : ceil(PCT*m), :);
    labelTrain = gridLabel(1 : ceil(PCT*m), :);
    dataTest = RSSMatrix(ceil(PCT*m) + 1 : end, :);
    labelTest = gridLabel(ceil(PCT*m) + 1 : end, :);
    x_real_test = x_real(ceil(PCT*m) + 1 : end);
    y_real_test = y_real(ceil(PCT*m) + 1 : end);
end

