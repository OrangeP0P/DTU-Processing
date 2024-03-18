%% 不同用户数据读取
basic_path = 'D:\DTU Data\Processed EEG data left-ear\'; % 基础读取路径
data_1 = Data_Trans_to_Electrode(basic_path, 4);
basic_path = 'D:\DTU Data\Processed EEG data right-ear\'; % 基础读取路径
data_2 = Data_Trans_to_Electrode(basic_path, 4);

%% 调整不同数据长度
lengths = [size(data_1, 2), size(data_2, 2)];
minLength = min(lengths); % 找到最短的长度
data_1 = data_1(:, 1:minLength); % 调整每个矩阵的长度
data_2 = data_2(:, 1:minLength);

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

%% TSNE
all_data = [data_1; data_2]; % 合并数据集
[coeff, score] = pca(all_data); % 通过PCA降维以减少数据集大小
% 使用barneshut算法执行t-SNE降维到3维
mappedX_3 = tsne(score,'NumDimensions',3);

%% t-SNE 3D可视化
num = 100; % 球面由多少个面组成
[X,Y,Z] = sphere(num); % 生成一个半径为1的球
r = 0.011; % 球体的半径
xlim([0 1])
ylim([0 1])
zlim([0 1])
FlattenedData_3 = mappedX_3(:)'; % 展开矩阵为一列，然后转置为一行。
MappedFlattened_3(:,1) = normalizeVector(mappedX_3(:,1), 0, 3); % 归一化。
MappedFlattened_3(:,2) = normalizeVector(mappedX_3(:,2), 0, 1); % 归一化。
MappedFlattened_3(:,3) = normalizeVector(mappedX_3(:,3), 0, 1); % 归一化。
MappedData_3 = reshape(MappedFlattened_3, size(mappedX_3)); % 还原为原始矩阵形式
% MappedData_3 = load('E:\学习\MY_Code\Matlab\XJTLU Master Project\10-TEGDAN-TSNE\BCI-III-IVa\task-3\tsne-1.mat').MappedData_3;

figure(1) % 生成新图
for sub = 1:2
    if sub == 3 % 源域
        color_index_3 = colormap("autumn"); % 生成颜色地图 hsv
        color_index_3 = color_index_3(1:4:255,:,:);
    elseif sub == 2 % 源域对齐后
        color_index_3 = colormap("summer"); % 生成颜色地图 hsv
        color_index_3 = color_index_3(118:2:255,:,:);
    elseif sub == 1 % 目标域对齐后
        color_index_3 = colormap("gray"); % 生成颜色地图 hsv
        color_index_3 = color_index_3(1:4:255,:,:);
    elseif sub == 4  % 生成域
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
        s_1.EdgeColor = 'none'; % 球体表面取消指示线
        material(s_1,"shiny") % 设置材质
        hold on
    end
    
    hold on
end
% set(gca,'xticklabel',X);
l2 = light; % 进行打光
l2.Color = [0.9 0.9 0.9]; % 使用稍暗的白光
l2.Position = [3.5, 0, 0]; 

% 设置当前图形的轴为不可见
axis off

% 关闭轴边框线
box off


% 关闭图例（如果有）
legend off

view(0, 90);