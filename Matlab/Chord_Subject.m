%% 不同用户数据读取
basic_path = 'D:\DTU Data\Processed EEG data left-ear\'; % 基础读取路径
subject_ID = 4;
data_1 = Data_Trans_to_Electrode(basic_path, subject_ID);

%% 将数据加载成EEGLab格式进行预处理
train_EEG = pop_importdata('setname','train', ...
    'data', data_1, ...
    'dataformat', 'array', ...
    'srate', 512, ...
    'nbchan', 64);
train_EEG = pop_reref(train_EEG, []); % 进行平均参考
train_EEG = pop_eegfilt(train_EEG, 4, 13); % 进行FIR滤波
data_1 = train_EEG.data;

% PCA降维
[coeff, processed_data] = pca(data_1'); % 注意PCA是对列进行操作，所以这里需要转置data_1

% 计算通道间皮尔逊相关系数
electrode_similarity = corr(processed_data, 'Type', 'Pearson');
disp(electrode_similarity);

% 分别保存正相关和负相关的系数
electrode_similarity_positive = electrode_similarity;
electrode_similarity_positive(electrode_similarity <= 0) = 0; % 将负相关和0的系数设置为0

electrode_similarity_negative = electrode_similarity;
electrode_similarity_negative(electrode_similarity >= 0) = 0; % 将正相关和0的系数设置为0
electrode_similarity_negative = abs(electrode_similarity_negative); % 将负相关系数取绝对值

%% 删选electrode_similarity_positive
n = 15;

% 将对角线元素设置为0，避免将自相关作为最大值处理
diagIndices = 1:size(electrode_similarity_positive, 1)+1:numel(electrode_similarity_positive);
electrode_similarity_positive(diagIndices) = 0;

% 找出并保留最大的n个系数
[sortedValues, ~] = sort(electrode_similarity_positive(:), 'descend');
if n < numel(sortedValues)
    thresholdValue = sortedValues(n);
else
    thresholdValue = sortedValues(end);
end

% 将小于第n大的值设置为0
electrode_similarity_positive(electrode_similarity_positive < thresholdValue) = 0;

%% 删选electrode_similarity_negative
electrode_similarity_negative(diagIndices) = 0; % 将对角线元素设置为0

% 找出并保留最大的n个系数（由于已经取了绝对值，直接排序即可）
[sortedValues, ~] = sort(electrode_similarity_negative(:), 'descend');
if n < numel(sortedValues)
    thresholdValue = sortedValues(n);
else
    thresholdValue = sortedValues(end);
end

% 将小于第n大的值设置为0
electrode_similarity_negative(electrode_similarity_negative < thresholdValue) = 0;

%% 归一化

% Normalize electrode_similarity_positive
max_value_positive = max(electrode_similarity_positive(:)); % Find the maximum value in the matrix
if max_value_positive > 0 % Avoid division by zero
    electrode_similarity_positive = electrode_similarity_positive / max_value_positive; % Divide by the maximum value to normalize
else
    disp('Positive similarity matrix is all zeros or negative values.');
end

% Normalize electrode_similarity_negative
max_value_negative = max(electrode_similarity_negative(:)); % Find the maximum value in the matrix
if max_value_negative > 0 % Avoid division by zero
    electrode_similarity_negative = electrode_similarity_negative / max_value_negative; % Divide by the maximum value to normalize
else
    disp('Negative similarity matrix is all zeros or positive values.');
end

%% 将正/负相关系数写入csv中
% 电极通道名称
channel_names = {'Fp1', 'AF7', 'AF3', 'F1', 'F3', 'F5', 'F7', 'FT7', 'FC5', 'FC3', 'FC1', ...
    'C1', 'C3', 'C5', 'T7', 'TP7', 'CP5', 'CP3', 'CP1', 'P1', 'P3', 'P5', ...
    'P7', 'P9', 'PO7', 'PO3', 'O1', 'Iz', 'Oz', 'POz', 'Pz', 'CPz', 'Fpz', ...
    'Fp2', 'AF8', 'AF4', 'AFz', 'Fz', 'F2', 'F4', 'F6', 'F8', 'FT8', 'FC6', ...
    'FC4', 'FC2', 'FCz', 'Cz', 'C2', 'C4', 'C6', 'T8', 'TP8', 'CP6', 'CP4', ...
    'CP2', 'P2', 'P4', 'P6', 'P8', 'P10', 'PO8', 'PO4', 'O2'};

% 将相关性矩阵转换为一个表格（table）
positiveTable = array2table(electrode_similarity_positive, 'VariableNames', channel_names, 'RowNames', channel_names);
negativeTable = array2table(electrode_similarity_negative, 'VariableNames', channel_names, 'RowNames', channel_names);

% 写入CSV文件
writetable(positiveTable, ['E:\学习\MY_Code\Matlab\XJTLU Master Project\13-Audio EEG\DTU Processing\Chord Subject\' ...
    'electrode_similarity_positive_S',num2str(subject_ID),'_C',num2str(n),'.csv'], 'WriteRowNames', true);
writetable(negativeTable, ['E:\学习\MY_Code\Matlab\XJTLU Master Project\13-Audio EEG\DTU Processing\Chord Subject\' ...
    'electrode_similarity_negative_S',num2str(subject_ID),'_C',num2str(n),'.csv'], 'WriteRowNames', true);
