%% 本段功能：将DTU数据集原始.mat文件中的EEG矩阵提取出来，并进行保存
% subject_ID = 5; 
% All_data = load(['D:\DTU Data\EEG\S',num2str(subject_ID),'.mat']);
% cnt_data = All_data.data.eeg{1};
% cnt_data = cnt_data';
% cnt_data = cnt_data(1:64,:); % 提取前64个通道的电极数据
% save(['D:\DTU Data\EEGLab Array Format\Subject All Data\S',num2str(subject_ID),'.mat'],'cnt_data')

%% 本段功能：提取Speaker 1/Speaker2数据中，不同用户的某个sample（Speaker的影响）
% subject_ID = 1; 
% sample_ID = 1300; % 选取的样本编号
% speaker_ID = 2;
% 
% All_data = load(['D:\DTU Data\Processed EEG data speaker ',num2str(speaker_ID),'\data_',num2str(subject_ID),'.mat']);
% field_name = ['data_', num2str(subject_ID)]; % 更新动态字段
% cnt_data = All_data.(field_name);
% data = cnt_data(sample_ID,:,1:64);
% data = reshape(data,[512,64]);
% data = data';
% save(['D:\DTU Data\EEGLab Array Format\Sample of Each Subject with One Speaker\S',num2str(subject_ID), ...
%     '_Speaker',num2str(speaker_ID),'_Sample',num2str(sample_ID),'.mat'],'data')

%% 本段功能：提取left-ear/right-ear中用户的某Sample数据

% subject_ID = 1;
% sample_ID = 1;
% All_data = load(['D:\DTU Data\Processed EEG data left-ear\data_',num2str(subject_ID),'.mat']);
% field_name = ['data_', num2str(subject_ID)]; % 更新动态字段
% cnt_data = All_data.(field_name);
% data_1 = cnt_data(sample_ID,:,1:64);
% data_1 = reshape(data_1,[512,64]);
% data_1 = data_1';
% save(['D:\DTU Data\EEGLab Array Format\Sample of Each Subject with One Ear\S',num2str(subject_ID), ...
%     '_Left-Ear','_Sample',num2str(sample_ID),'.mat'],'data_1')
% 
% All_data = load(['D:\DTU Data\Processed EEG data right-ear\data_',num2str(subject_ID),'.mat']);
% field_name = ['data_', num2str(subject_ID)]; % 更新动态字段
% cnt_data = All_data.(field_name);
% data_2 = cnt_data(sample_ID,:,1:64);
% data_2 = reshape(data_2,[512,64]);
% data_2 = data_2';
% save(['D:\DTU Data\EEGLab Array Format\Sample of Each Subject with One Ear\S',num2str(subject_ID), ...
%     '_Right-Ear','_Sample',num2str(sample_ID),'.mat'],'data_2')

%% 本段功能：提取left-ear/right-ear中用户的所有数据
% subject_ID = 2;
% All_data = load(['D:\DTU Data\Processed EEG data left-ear\data_',num2str(subject_ID),'.mat']);
% field_name = ['data_', num2str(subject_ID)]; % 更新动态字段
% cnt_data = All_data.(field_name);
% cnt_data = permute(cnt_data, [3, 2, 1]); % 将维度重排为 73x512x1500
% cnt_data = reshape(cnt_data, 73, 512*1500);
% data = cnt_data(1:64,:);
% train_EEG = pop_importdata('setname','train', ...
%     'data', data, ...
%     'dataformat', 'array', ...
%     'srate', 512, ...
%     'nbchan', 64);
% train_EEG = pop_reref(train_EEG, []); % 进行平均参考
% train_EEG = pop_eegfilt(train_EEG, 4, 13); % 进行FIR滤波
% data = train_EEG.data;
% save(['D:\DTU Data\EEGLab Array Format\All Data of Each Subject with One Ear\S',num2str(subject_ID), ...
%     '_Left-Ear','.mat'],'data')
% 
% All_data = load(['D:\DTU Data\Processed EEG data right-ear\data_',num2str(subject_ID),'.mat']);
% field_name = ['data_', num2str(subject_ID)]; % 更新动态字段
% cnt_data = All_data.(field_name);
% cnt_data = permute(cnt_data, [3, 2, 1]); % 将维度重排为 73x512x1500
% cnt_data = reshape(cnt_data, 73, 512*1600);
% data = cnt_data(1:64,:);
% train_EEG = pop_importdata('setname','train', ...
%     'data', data, ...
%     'dataformat', 'array', ...
%     'srate', 512, ...
%     'nbchan', 64);
% train_EEG = pop_reref(train_EEG, []); % 进行平均参考
% train_EEG = pop_eegfilt(train_EEG, 4, 13); % 进行FIR滤波
% data = train_EEG.data;
% save(['D:\DTU Data\EEGLab Array Format\All Data of Each Subject with One Ear\S',num2str(subject_ID), ...
%     '_Right-Ear','.mat'],'data')

%% 本段功能：提取Speaker 1/Speaker 2中用户的所有数据
subject_ID = 2;
All_data = load(['D:\DTU Data\Processed EEG data speaker 1\data_',num2str(subject_ID),'.mat']);
field_name = ['data_', num2str(subject_ID)]; % 更新动态字段
cnt_data = All_data.(field_name);
cnt_data = permute(cnt_data, [3, 2, 1]); % 将维度重排为 73x512x1500
cnt_data = reshape(cnt_data, 73, 512*1500);
data = cnt_data(1:64,:);
% train_EEG = pop_importdata('setname','train', ...
%     'data', data, ...
%     'dataformat', 'array', ...
%     'srate', 512, ...
%     'nbchan', 64);
% train_EEG = pop_reref(train_EEG, []); % 进行平均参考
% train_EEG = pop_eegfilt(train_EEG, 4, 13); % 进行FIR滤波
% data = train_EEG.data;
save(['D:\DTU Data\EEGLab Array Format\All Data of Each Subject with One Speaker\S',num2str(subject_ID), ...
    '_Speaker1','.mat'],'data')

All_data = load(['D:\DTU Data\Processed EEG data speaker 2\data_',num2str(subject_ID),'.mat']);
field_name = ['data_', num2str(subject_ID)]; % 更新动态字段
cnt_data = All_data.(field_name);
cnt_data = permute(cnt_data, [3, 2, 1]); % 将维度重排为 73x512x1500
cnt_data = reshape(cnt_data, 73, 512*1500);
data = cnt_data(1:64,:);
% train_EEG = pop_importdata('setname','train', ...
%     'data', data, ...
%     'dataformat', 'array', ...
%     'srate', 512, ...
%     'nbchan', 64);
% train_EEG = pop_reref(train_EEG, []); % 进行平均参考
% train_EEG = pop_eegfilt(train_EEG, 4, 13); % 进行FIR滤波
% data = train_EEG.data;
save(['D:\DTU Data\EEGLab Array Format\All Data of Each Subject with One Speaker\S',num2str(subject_ID), ...
    '_Speaker2','.mat'],'data')