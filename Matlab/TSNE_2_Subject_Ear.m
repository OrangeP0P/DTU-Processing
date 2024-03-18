%% 不同用户数据读取
basic_path = 'D:\DTU Data\Processed EEG data left-ear\'; % 基础读取路径
data_1 = Data_Trans_to_Electrode(basic_path, 2);
basic_path = 'D:\DTU Data\Processed EEG data right-ear\'; % 基础读取路径
data_2 = Data_Trans_to_Electrode(basic_path, 2);

basic_path = 'D:\DTU Data\Processed EEG data left-ear\'; % 基础读取路径
data_3 = Data_Trans_to_Electrode(basic_path, 4);
basic_path = 'D:\DTU Data\Processed EEG data right-ear\'; % 基础读取路径
data_4 = Data_Trans_to_Electrode(basic_path, 4);

%% 调整不同数据长度
lengths = [size(data_1, 2), size(data_2, 2), size(data_3, 2), size(data_4, 2)];
minLength = min(lengths); % 找到最短的长度
data_1 = data_1(:, 1:minLength); % 调整每个矩阵的长度
data_2 = data_2(:, 1:minLength);
data_3 = data_3(:, 1:minLength); % 调整每个矩阵的长度
data_4 = data_4(:, 1:minLength);

%% 将数据加载成EEGLab格式进行预处理
train_EEG = pop_importdata('setname','train', ...
    'data', data_1, ...
    'dataformat', 'array', ...
    'srate', 512, ...
    'nbchan', 64);
train_EEG = pop_reref(train_EEG, []); % 进行平均参考
train_EEG = pop_eegfilt(train_EEG, 4, 13); % 进行FIR滤波
data_1 = train_EEG.data;

train_EEG = pop_importdata('setname','train', ...
    'data', data_2, ...
    'dataformat', 'array', ...
    'srate', 512, ...
    'nbchan', 64);
train_EEG = pop_reref(train_EEG, []); % 进行平均参考
train_EEG = pop_eegfilt(train_EEG, 4, 13); % 进行FIR滤波
data_2 = train_EEG.data;

train_EEG = pop_importdata('setname','train', ...
    'data', data_3, ...
    'dataformat', 'array', ...
    'srate', 512, ...
    'nbchan', 64);
train_EEG = pop_reref(train_EEG, []); % 进行平均参考
train_EEG = pop_eegfilt(train_EEG, 4, 13); % 进行FIR滤波
data_3 = train_EEG.data;

train_EEG = pop_importdata('setname','train', ...
    'data', data_4, ...
    'dataformat', 'array', ...
    'srate', 512, ...
    'nbchan', 64);
train_EEG = pop_reref(train_EEG, []); % 进行平均参考
train_EEG = pop_eegfilt(train_EEG, 4, 13); % 进行FIR滤波
data_4 = train_EEG.data;

%% TSNE
all_data = [data_1; data_2; data_3; data_4]; % 合并数据集
[coeff, score] = pca(all_data); % 通过PCA降维以减少数据集大小
mappedX_3 = tsne(score,'NumDimensions',3); % 使用barneshut算法执行t-SNE降维到3维

%% t-SNE 3D可视化
electrodeNames = {'Fp1', 'AF7', 'AF3', 'F1', 'F3', 'F5', 'F7', 'FT7', 'FC5', 'FC3', 'FC1', 'C1', 'C3', 'C5', 'T7', 'TP7', 'CP5', 'CP3', 'CP1', 'P1', 'P3', 'P5', 'P7', 'P9', 'PO7', 'PO3', 'O1', 'Iz', 'Oz', 'POz', 'Pz', 'CPz', 'Fpz', 'Fp2', 'AF8', 'AF4', 'AFz', 'Fz', 'F2', 'F4', 'F6', 'F8', 'FT8', 'FC6', 'FC4', 'FC2', 'FCz', 'Cz', 'C2', 'C4', 'C6', 'T8', 'TP8', 'CP6', 'CP4', 'CP2', 'P2', 'P4', 'P6', 'P8', 'P10', 'PO8', 'PO4', 'O2'};
num = 100; % 球面由多少个面组成
[X,Y,Z] = sphere(num); % 生成一个半径为1的球
r = 0.01; % 球体的半径
xlim([0 1])
ylim([0 1])
zlim([0 1])
FlattenedData_3 = mappedX_3(:)'; % 展开矩阵为一列，然后转置为一行。
MappedFlattened_3(:,1) = normalizeVector(mappedX_3(:,1), 0, 3); % 归一化。
MappedFlattened_3(:,2) = normalizeVector(mappedX_3(:,2), 0, 1); % 归一化。
MappedFlattened_3(:,3) = normalizeVector(mappedX_3(:,3), 0, 1); % 归一化。
MappedData_3 = reshape(MappedFlattened_3, size(mappedX_3)); % 还原为原始矩阵形式
% MappedData_3 = load('E:\学习\MY_Code\Matlab\XJTLU Master Project\10-TEGDAN-TSNE\BCI-III-IVa\task-3\tsne-1.mat').MappedData_3;

% 灰色+绿色  红色+紫色
figure(1) % 生成新图
for sub = 1:4
    if sub == 1 % 红色
        color_index_3 = colormap("autumn"); % 生成颜色地图 hsv
        color_index_3 = color_index_3(1:4:255,:,:);
    elseif sub == 4 % 绿色
        color_index_3 = colormap("summer"); % 生成颜色地图 hsv
        color_index_3 = color_index_3(118:2:255,:,:);
    elseif sub == 3 % 灰色
        color_index_3 = colormap("gray"); % 生成颜色地图 hsv
        color_index_3 = color_index_3(1:4:255,:,:);
    elseif sub == 2  % 生成域
        color_index_3 = colormap("cool"); % 生成颜色地图 hsv
        color_index_3 = color_index_3(120:2:256,:,:);
    else
        color_index_3 = colormap("winter"); % 生成颜色地图 hsv
        color_index_3 = color_index_3([40:5:100, 120:5:190],:,:);
    end
    for ch = 1:64
        c = zeros(size(X)); % 三维电极球体上色矩阵
        for i = 1:1:length(c(1,:))
            for j = 1:1:length(c(:,1))
                c(i,j,1) = color_index_3(ch,1); % RGB R通道
                c(i,j,2) = color_index_3(ch,2); % RGB G通道
                c(i,j,3) = color_index_3(ch,3); % RGB B通道
            end
        end
        s_1 = surf(X*r + MappedData_3(ch+64*(sub-1),1), Y*r + MappedData_3(ch+64*(sub-1),2), ...
                   Z*r + MappedData_3(ch+64*(sub-1),3), c); % 绘制不同电极的球体


%         % 调整文本标签的设置
%         x = MappedData_3(ch+64*(sub-1),1) + 1.1*r;
%         y = MappedData_3(ch+64*(sub-1),2);
%         z = MappedData_3(ch+64*(sub-1),3);
%         textStr = electrodeNames{ch}; % 使用电极通道名称替代数字编号
%     
%         % 将原始颜色变暗以用于文本
%         darkenFactor = 0.5; % 亮度降低比例
% %         textColor = max(0, color_index_3(ch,:) * darkenFactor);
%         
%         % 绘制文本
%         text(x, y, z, textStr, 'Color', [0,0,0], 'FontSize', 10, 'FontWeight', 'bold', ...
%             'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle');

        s_1.EdgeColor = 'none'; % 球体表面取消指示线
        material(s_1,"shiny") % 设置材质
        hold on
    end
    
    hold on
end

l2 = light; % 进行打光
l2.Color = [0.9 0.9 0.9]; % 使用稍暗的白光
l2.Position = [3.5, 0, 0]; 

axis off % 设置当前图形的轴为不可见
box off % 关闭轴边框线
legend off % 关闭图例
view(0, 90);