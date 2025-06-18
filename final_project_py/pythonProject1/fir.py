import numpy as np

import matplotlib.pyplot
matplotlib.use("TkAgg")  # 解決 backend 錯誤
import matplotlib.pyplot as plt
plt.rcParams['font.family'] = 'Microsoft YaHei'  # 解決中文字無法顯示
from scipy.io import wavfile
from scipy.signal import lfilter

# 讀取音檔
sample_rate, data = wavfile.read("output.wav")

# 若是立體聲（2D），只取一個聲道
if data.ndim > 1:
    data = data[:, 0]

# 設定移動平均濾波器（5點平均）
b = np.ones(5) / 5  # 濾波器係數
a = [1]             # FIR 濾波器

# 濾波處理
filtered_data = lfilter(b, a, data)

# 避免超出音訊格式範圍，將資料轉換為 int16 格式（音訊標準格式）
filtered_data = np.clip(filtered_data, -32768, 32767).astype(np.int16)

# 儲存濾波後的音訊
wavfile.write("filtered_output.wav", sample_rate, filtered_data)
print("已儲存為 filtered_output.wav")

# 畫出原始與濾波後波形比較
time = np.linspace(0, len(data) / sample_rate, num=len(data))

plt.figure(figsize=(12, 6))

plt.subplot(2, 1, 1)
plt.plot(time, data, label='原始波形', color='blue')
plt.title('原始 vs 濾波後波形（移動平均濾波）')
plt.xlabel('時間 (秒)')
plt.ylabel('振幅')
plt.legend()

plt.subplot(2, 1, 2)
plt.plot(time, filtered_data, label='濾波後波形', color='green')
plt.xlabel('時間 (秒)')
plt.ylabel('振幅')
plt.legend()

plt.tight_layout()
plt.show()
