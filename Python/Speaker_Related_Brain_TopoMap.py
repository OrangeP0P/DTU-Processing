import mne
from scipy.io import loadmat
import numpy as np
import matplotlib.pyplot as plt
from matplotlib import ticker

######################### 步骤1: 读取.mat文件 ########################
data_path = 'D:\DTU Data\EEGLab Array Format\All Data of Each Subject with One Speaker/'
data_name = ['S2_Speaker1', 'S2_Speaker2', 'S2_Speaker1_Sample5', 'S2_Speaker2_Sample1']
data_ID = 0
mat = loadmat(data_path+data_name[data_ID]+'.mat')
data = mat['data']

######################### 步骤3: 创建信息对象 ########################
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

# 设置数据电极montage
biosemi64_montage = mne.channels.make_standard_montage('biosemi64')

# 所有通道类型都为EEG
ch_types = ['eeg'] * len(ch_names)  # 生成一个与通道名称等长的，填充'eeg'的列表
info = mne.create_info(ch_names=ch_names, sfreq=sfreq, ch_types=ch_types)

######################## 步骤4: 创建 MNE 数据结构 ########################
raw = mne.io.RawArray(data, info)
raw.set_montage(biosemi64_montage)

# 绘制大脑地形图
mean_data = raw.get_data().mean(axis=1)  # 计算电压百分比
data = raw.get_data()
min_voltage = mean_data.min()
max_voltage = mean_data.max()

# 将电压转换为百分比（0-100%）
voltage_percent = (mean_data - min_voltage) / (max_voltage - min_voltage) * 100

# 绘制大脑地形图，使用百分比电压和新的颜色映射
fig, ax = plt.subplots()
im, _ = mne.viz.plot_topomap(voltage_percent, raw.info, cmap='RdBu_r', res=2000, axes=ax, show=False, contours=10)
plt.savefig('Figure-TopoMap/Speaker Topo Map/'+'Map'+data_name[data_ID]+'.eps', dpi=600)