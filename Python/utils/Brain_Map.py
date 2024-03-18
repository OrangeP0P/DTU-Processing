import mne
from scipy.io import loadmat
import numpy as np
import matplotlib.pyplot as plt
from matplotlib import ticker

# 设置数据电极montage
biosemi64_montage = mne.channels.make_standard_montage('biosemi64')
# biosemi64_montage.plot()

# 步骤1: 读取.mat文件
mat = loadmat('EEG Data/S1.mat')
data = mat['cnt_data']  # 假设数据存储在名为'data'的键中

# 步骤3: 创建信息对象
sfreq = 512  # 采样率
ch_names = [
    'Fp1', 'AF7', 'AF3', 'F1', 'F3', 'F5', 'F7', 'FT7', 'FC5', 'FC3', 'FC1',
    'C1', 'C3', 'C5', 'T7', 'TP7', 'CP5', 'CP3', 'CP1', 'P1', 'P3', 'P5',
    'P7', 'P9', 'PO7', 'PO3', 'O1', 'Iz', 'Oz', 'POz', 'Pz', 'CPz', 'Fpz',
    'Fp2', 'AF8', 'AF4', 'AFz', 'Fz', 'F2', 'F4', 'F6', 'F8', 'FT8', 'FC6',
    'FC4', 'FC2', 'FCz', 'Cz', 'C2', 'C4', 'C6', 'T8', 'TP8', 'CP6', 'CP4',
    'CP2', 'P2', 'P4', 'P6', 'P8', 'P10', 'PO8', 'PO4', 'O2'
]
event_id = {'Speaker': 1, 'Speaker': 2}

# 所有通道类型都为EEG
ch_types = ['eeg'] * len(ch_names)  # 生成一个与通道名称等长的，填充'eeg'的列表
info = mne.create_info(ch_names=ch_names, sfreq=sfreq, ch_types=ch_types)

# 步骤4: 创建 MNE 数据结构
raw = mne.io.RawArray(data, info)
raw.set_montage(biosemi64_montage)

# 绘制指定时间点（例如1秒处）的地形图
fig, ax = plt.subplots(figsize=(6, 4))
plt.rcParams['font.family'] = 'Arial'
time_point = 1.0  # 单位为秒
fig = raw.plot_psd(fmin=0.1, fmax=40, show=False).figure  # 获取 Figure 对象
ax = fig.axes[0]  # 假设你的图表是单轴的，并获取该轴

# 设置轴标签的字体大小和粗细
ax.set_xlabel('X轴标签', fontsize=14, fontweight='bold')
ax.set_ylabel('Y轴标签', fontsize=14, fontweight='bold')
fig.set_size_inches(6, 4, forward=True)
fig.savefig('psd_plot.png', dpi=600, transparent=True)  # 使用 transparent=True 使背景透明
plt.close(fig)  # 关闭图像





