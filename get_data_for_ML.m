function [ dataTrain, labelTrain, dataTest, labelTest, x_real_test, y_real_test ] = get_data_for_ML( radioMap, m )
%get_data_for_ML: 
%get data from a radio map, preparing for localization test.
    if nargin == 1
        m = 20000; %number of collected samples
    end
    n = size(radioMap, 3);%number of APs
    [RSSMatrix, gridLabel, x_real, y_real] = fp_collection(radioMap, n, m);
    PCT = 0.7;%percentage
    dataTrain = RSSMatrix(1 : ceil(PCT*m), :);
    labelTrain = gridLabel(1 : ceil(PCT*m), :);
    dataTest = RSSMatrix(ceil(PCT*m) + 1 : end, :);
    labelTest = gridLabel(ceil(PCT*m) + 1 : end, :);
    x_real_test = x_real(ceil(PCT*m) + 1 : end);
    y_real_test = y_real(ceil(PCT*m) + 1 : end);
end

