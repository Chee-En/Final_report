import numpy as np
import matplotlib.pyplot
matplotlib.use("TkAgg")  # 解決 backend 錯誤
import matplotlib.pyplot as plt
import scipy.io.wavfile as wavfile
import scipy.signal as signal

# 設定字體為微軟正黑體以顯示中文
plt.rcParams['font.family'] = 'Microsoft YaHei'

# 讀取 wav 音檔
sample_rate, data = wavfile.read("output.wav")

# 如果是立體聲，取一個聲道
if data.ndim > 1:
    data = data[:, 0]

# 正規化資料為 float32
data = data.astype(np.float32)
if data.max() > 1.0:
    data /= np.max(np.abs(data))

# 自訂 FIR 濾波器係數
fir_coeff = [0.25, 0.5, 0.25]

# 應用濾波器
filtered = signal.lfilter(fir_coeff, 1.0, data)

# 若要存回 WAV 檔，需反正規化並轉成 int16
output_data = np.int16(filtered / np.max(np.abs(filtered)) * 32767)
wavfile.write("output_filtered.wav", sample_rate, output_data)

# 畫圖比對
time = np.arange(len(data)) / sample_rate

plt.figure(figsize=(12, 6))
plt.plot(time, data, label="原始音訊", alpha=0.6)
plt.plot(time, filtered, label="濾波後音訊", alpha=0.8)
plt.title("濾波前後波形（移動平均濾波器）")
plt.xlabel("時間（秒）")
plt.ylabel("振幅")
plt.legend()
plt.tight_layout()
plt.show()
