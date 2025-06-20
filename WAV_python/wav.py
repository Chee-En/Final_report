import tkinter as tk
from tkinter import ttk, messagebox
import serial
import serial.tools.list_ports
import numpy as np
import wave
import struct
import threading
import matplotlib.pyplot as plt
from matplotlib.backends.backend_tkagg import FigureCanvasTkAgg
plt.rcParams['font.family'] = 'Microsoft YaHei'

SAMPLE_RATE = 44000
BAUD_RATE = 115200

class SerialRecorderGUI:
    def __init__(self, master):
        self.master = master
        master.title("對比濾波前與濾波後音訊 +波形圖")

        self.serial_port = None
        self.recording = False
        self.origin_samples = []
        self.filter_samples = []

        # GUI 控制元件
        tk.Label(master, text="選擇 COM Port:").pack()
        self.port_combobox = ttk.Combobox(master, values=self.list_serial_ports())
        self.port_combobox.pack()

        self.start_button = tk.Button(master, text="開始錄音", command=self.start_recording_thread)
        self.start_button.pack(pady=5)

        self.stop_button = tk.Button(master, text="停止錄音", command=self.stop_recording, state=tk.DISABLED)
        self.stop_button.pack(pady=5)

        self.status = tk.Label(master, text="狀態：等待中")
        self.status.pack()

        # Matplotlib 畫布
        self.fig, self.axs = plt.subplots(2, 1, figsize=(6, 4), dpi=100)
        self.fig.tight_layout()
        self.canvas = FigureCanvasTkAgg(self.fig, master)
        self.canvas.get_tk_widget().pack(padx=10, pady=10)

    def list_serial_ports(self):
        ports = [port.device for port in serial.tools.list_ports.comports()]
        return ports if ports else ["無可用 COM Port"]

    def start_recording_thread(self):
        thread = threading.Thread(target=self.record_audio)
        thread.start()

    def record_audio(self):
        port = self.port_combobox.get()
        if "COM" not in port:
            messagebox.showerror("錯誤", "請選擇正確的 COM port")
            return

        try:
            self.serial_port = serial.Serial(port, BAUD_RATE, timeout=1)
            self.origin_samples = []
            self.filter_samples = []
            self.recording = True

            self.status.config(text="狀態：錄音中...")
            self.start_button.config(state=tk.DISABLED)
            self.stop_button.config(state=tk.NORMAL)

            while self.recording:
                line = self.serial_port.readline().decode('utf-8', errors='ignore').strip()
                if line.startswith("Origin_Data:"):
                    try:
                        value = int(line.replace("Origin_Data:", "").strip())
                        if 0 <= value <= 4095:
                            self.origin_samples.append(value)
                    except:
                        pass
                elif line.startswith("filter_Data:"):
                    try:
                        value = int(line.replace("filter_Data:", "").strip())
                        if 0 <= value <= 4095:
                            self.filter_samples.append(value)
                    except:
                        pass

            self.serial_port.close()
            self.status.config(text="狀態：轉換 WAV...")

            self.save_as_wav("audio_origin.wav", self.origin_samples)
            self.save_as_wav("audio_filter.wav", self.filter_samples)

            self.status.config(text="狀態：已完成儲存，顯示波形中")
            self.plot_waveforms()

            messagebox.showinfo("完成", "音訊已儲存並繪製波形圖")
            self.start_button.config(state=tk.NORMAL)
            self.stop_button.config(state=tk.DISABLED)

        except Exception as e:
            self.status.config(text="狀態：發生錯誤")
            messagebox.showerror("錯誤", str(e))
            self.start_button.config(state=tk.NORMAL)
            self.stop_button.config(state=tk.DISABLED)

    def stop_recording(self):
        self.recording = False
        self.status.config(text="狀態：停止錄音中...")

    def save_as_wav(self, filename, data_list):
        data = np.array(data_list, dtype=np.int16)
        data = data - 2048
        data = (data / 2048.0 * 32767.0).astype(np.int16)

        with wave.open(filename, 'wb') as wf:
            wf.setnchannels(1)
            wf.setsampwidth(2)
            wf.setframerate(SAMPLE_RATE)
            wf.writeframes(b''.join(struct.pack('<h', s) for s in data))

        print(f"{filename} 已成功建立。")

    def plot_waveforms(self):
        self.axs[0].clear()
        self.axs[1].clear()

        N = min(len(self.origin_samples), len(self.filter_samples), 5000)
        t = np.linspace(0, N / SAMPLE_RATE, N)

        origin = np.array(self.origin_samples[:N]) - 2048
        filterd = np.array(self.filter_samples[:N]) - 2048

        self.axs[0].plot(t, origin, color='blue')
        self.axs[0].set_title("原始音訊 (audio_origin.wav)")
        self.axs[0].set_ylabel("振幅")
        self.axs[0].set_ylim(-2048, 2048)

        self.axs[1].plot(t, filterd, color='green')
        self.axs[1].set_title("濾波後音訊 (audio_filter.wav)")
        self.axs[1].set_xlabel("時間 (秒)")
        self.axs[1].set_ylabel("振幅")
        self.axs[1].set_ylim(-2048, 2048)

        self.canvas.draw()


if __name__ == "__main__":
    root = tk.Tk()
    app = SerialRecorderGUI(root)
    root.mainloop()
