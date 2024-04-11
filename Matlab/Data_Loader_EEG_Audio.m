for subject_ID = 1:5
    %% 数据及重要索引读取
    Data_Path = 'D:\DTU Data\EEG\'; % 数据集路径
    data_save_path = 'D:\DTU Data\Processed EEG Audio data'; % EEG数据存储数据
    window_duration = 1; % 时间窗长度/s
    sampling_rate = 512; % 采样率/Hz
    trial_time = 50; % 每个trial的持续时间/s
    all_data = load([Data_Path,'S',num2str(subject_ID),'.mat']);
    raw_EEG_data = all_data.data.eeg{1}; % 读取原始EEG数据
    raw_EEG_data = raw_EEG_data(:,1:64);
    attend_mf_label = all_data.expinfo.attend_mf; % 听觉注意Speaker标签
    attend_lr_label = all_data.expinfo.attend_lr; % 听觉注意左右耳标签
    trial_trigger = all_data.expinfo.trigger; % 事件触发编码
    n_speakers = all_data.expinfo.n_speakers; % 参与说话个数，其==2为有效trial
    sample_cue = all_data.data.event.eeg.sample; % 每个trial起始采样点数
    sample_trigger = all_data.data.event.eeg.value; % 每个trial的对应触发编码
    sample_trigger = cell2mat(sample_trigger);
    wavefile_male = all_data.expinfo.wavfile_male; % 每个trial的男性音频文件名
    wavefile_female = all_data.expinfo.wavfile_female; % 每个trial的女性音频文件名

    %% 删除非听觉任务的Trial：条件为 n_speakers == 1
    id = n_speakers(:) == 1; % 提取非任务的trial编号
    attend_mf_label(id) = [];
    attend_lr_label(id) = [];
    trial_trigger(id) = [];
    wavefile_male(id) = [];
    wavefile_female(id) = [];

    %% 根据trial_trigger读取听觉注意任务的索引
    trial_ID = zeros(1, length(trial_trigger)); % 初始化结果向量
    startIndex = 1; % 初始化搜索的起始索引
    for i = 1:length(trial_trigger)
        foundIndex = find(sample_trigger(startIndex:end) == trial_trigger(i), 1) + startIndex - 1;
        if isempty(foundIndex) % 检查是否找到索引
            error('未找到匹配的索引。');
        else
            trial_ID(i) = foundIndex;
            startIndex = foundIndex + 1;
        end
    end
    trial_cue = sample_cue(trial_ID); % 听觉任务的cue
    
    %% 分割EEG数据集
    trial_num = size(trial_cue,1); % 读取trial个数
    window_size = sampling_rate * window_duration; % 裁切窗口大小
    window_sample_num = round(trial_time/window_duration); % 窗内样本的总个数
    
    n_sample = 1; % 初始化样本索引值
    cnt_subject = [];
    label_subject = [];
    for trial = 1:trial_num
        cue_EEG = trial_cue(trial); % 索引值
        label_speaker = attend_mf_label(trial); % 关注的说话者label
        label_ear = attend_lr_label(trial); % 关注的耳朵label
        % 读取对应trial的男生、女生音频文件，并降采样到512Hz
        [audio_male_data, Fs] = audioread(['D:\DTU Data\AUDIO\', wavefile_male{trial}]);
        [audio_female_data, Fs] = audioread(['D:\DTU Data\AUDIO\', wavefile_female{trial}]);
        audio_male_data = resample(audio_male_data, 512, Fs);
        audio_female_data = resample(audio_female_data, 512, Fs);
        cue_Audio = 1; % 音频裁切指示
        for sample = 1:window_sample_num
            I_EEG = raw_EEG_data(cue_EEG:cue_EEG+window_size-1,:);
            I_audio_male = audio_male_data(cue_Audio:cue_Audio+window_size-1,:);
            I_audio_female = audio_female_data(cue_Audio:cue_Audio+window_size-1,:);
            I_All = [I_EEG I_audio_male I_audio_female];
            cnt_subject(n_sample, :, :) = I_All;
            label_subject(n_sample, :, :) = label_ear;
            cue_EEG = cue_EEG + window_size;
            cue_Audio = cue_Audio + window_size;
            n_sample = n_sample + 1;
        end
    end
    
    %% 保存数据
    cnt_save_name = ['data_', int2str(subject_ID)]; % cnt数据保存名称
    label_save_name = ['label_', int2str(subject_ID)]; % label数据保存名称
    eval([cnt_save_name,'=cnt_subject',';']); % 将字符串转换为matlab可执行语句
    eval([label_save_name,'=label_subject',';']); % 将字符串转换为matlab可执行语句
    save([data_save_path,'\data_', int2str(subject_ID),'.mat'],['data_', int2str(subject_ID)]);
    save([data_save_path,'\label_', int2str(subject_ID),'.mat'],['label_', int2str(subject_ID)]);
end
