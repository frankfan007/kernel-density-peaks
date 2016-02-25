%% ʹ��K-means�����ݽ��о������,�����㾫ȷ��

%% Initialization
clear ; close all; clc

% Load Training Data
fprintf('Loading Data\n');
% 399*3���Լ�
% load('data1.mat');
% �β�����ݼ�
% load('iris.mat');
% data1 = data(:,3);
% data2 = data(:,4);
% label = data(:,5);
% data = [data1, data2, label];
% ������ݼ�
% load('wine.mat');
% data1 = data(:,1);
% data2 = data(:,12);
% label = data(:,14);
% data = [data1, data2, label];
% glass���ݼ�
load('glass.mat');
data1 = data(:,3);
data2 = data(:,7);
label = data(:,10);
data = [data1, data2, label];

% ���������
max_cluster_num = max(data(:,3));
accury = zeros(1, max_cluster_num);
time_compute = zeros(1, max_cluster_num);

for cluster_num = 1:max_cluster_num*2
    opts = statset('Display','final');
    time_before = now;
    [idx,C] = kmeans(data(:,1:2),cluster_num,'Distance','cityblock',...
        'Replicates',5,'Options',opts);
    time_after = now;
    time_compute(cluster_num) = time_after-time_before;
    accury(cluster_num) = AccMeasure(data(:,3), idx);
end