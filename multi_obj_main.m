clc;
clear;

addpath(genpath(pwd));
load DFL_radio_map;
noise = 2;
fingerprint = fingerprint + normrnd(0, noise, size(fingerprint)); % add noise
m = size(fingerprint, 3);

[ dataTrain, labelTrain] = get_data_for_ML( fingerprint, 10000 );

%% test single object




% load testData;