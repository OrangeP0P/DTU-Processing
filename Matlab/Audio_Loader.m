[audio_data,Fs] = audioread('D:\DTU Data\AUDIO\aske_story1_trial_1.wav');
audio_data = resample(audio_data, 512, Fs);