function EEG_data_reshaped = Data_Trans_to_Electrode(basic_path, subject_ID)
    EEG_data = load([basic_path,'data_',num2str(subject_ID),'.mat']); % 数据读取
    field_name = ['data_', num2str(subject_ID)]; % 更新动态字段
    EEG_data = EEG_data.(field_name); % 读取字段中的数据
    EEG_data = EEG_data(:,:,1:64); % 取前64个电极数据
    
    %% 格式转换 原始格式：样本×采样点×通道 ➡ 通道×（样本×采样点）
    EEG_data_permuted = permute(EEG_data, [3, 1, 2]);
    EEG_data_reshaped = reshape(EEG_data_permuted, 64, []);
end