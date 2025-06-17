import tkinter as tk
from tkinter import ttk, messagebox
import serial
import serial.tools.list_ports
import threading
import numpy as np
import wave
import csv
import time
import matplotlib.pyplot as plt
from matplotlib.backends.backend_tkagg import FigureCanvasTkAgg

class SerialRecorderGUI:
    def __init__(self, root):
        self.root = root
        self.root.title("Serial Audio Recorder (0~4095 to WAV)")
        self.root.geometry("600x400")

        ttk.Label(root, text="Select COM Port:").pack(pady=5)
        self.combobox = ttk.Combobox(root, values=self.get_com_ports(), state="readonly")
        self.combobox.pack(pady=5)

        self.start_button = ttk.Button(root, text="Start Recording", command=self.start_recording)
        self.start_button.pack(pady=5)

        self.pause_button = ttk.Button(root, text="Pause", command=self.toggle_pause, state=tk.DISABLED)
        self.pause_button.pack(pady=5)

        self.save_button = ttk.Button(root, text="Save as WAV + CSV", command=self.save_data, state=tk.DISABLED)
        self.save_button.pack(pady=5)

        self.status_label = ttk.Label(root, text="Status: Idle")
        self.status_label.pack(pady=5)

        self.time_label = ttk.Label(root, text="Elapsed: 0.0 s")
        self.time_label.pack(pady=5)

        self.recording = False
        self.paused = False
        self.buf = []
        self.sample_rate = 44000
        self.start_time = None

        # Plot area
        self.fig, self.ax = plt.subplots(figsize=(5, 2))
        self.line, = self.ax.plot([], [], lw=1)
        self.ax.set_ylim(-1.0, 1.0)
        self.ax.set_xlim(0, 1000)
        self.ax.set_title("Live Signal")
        self.ax.set_xlabel("Samples")
        self.ax.set_ylabel("Amplitude")
        self.canvas = FigureCanvasTkAgg(self.fig, master=root)
        self.canvas.get_tk_widget().pack()

    def get_com_ports(self):
        return [p.device for p in serial.tools.list_ports.comports()]

    def start_recording(self):
        port = self.combobox.get()
        if not port:
            messagebox.showwarning("COM Port Required", "Please select a COM port.")
            return

        self.recording = True
        self.paused = False
        self.buf = []
        self.start_time = time.time()

        self.status_label.config(text="Recording...")
        self.start_button.config(state=tk.DISABLED)
        self.pause_button.config(state=tk.NORMAL)
        self.save_button.config(state=tk.NORMAL)

        threading.Thread(target=self.record_serial_data, daemon=True).start()
        threading.Thread(target=self.update_plot_loop, daemon=True).start()

    def toggle_pause(self):
        self.paused = not self.paused
        self.pause_button.config(text="Resume" if self.paused else "Pause")
        self.status_label.config(text="Paused" if self.paused else "Recording...")

    def update_plot_loop(self):
        while self.recording:
            if not self.paused:
                self.update_gui_status()
            time.sleep(0.05)

    def update_gui_status(self):
        elapsed = time.time() - self.start_time if self.start_time else 0
        rate = len(self.buf) / (elapsed + 1e-5)
        self.time_label.config(text=f"Elapsed: {elapsed:.1f} s | Rate: {rate:.1f} Hz")

        if self.buf:
            view_size = 300
            recent = self.buf[-view_size:]
            normalized = (np.array(recent, dtype=np.uint16) - 2048) / 2048.0
            self.line.set_ydata(normalized)
            self.line.set_xdata(np.arange(len(normalized)))
            self.ax.set_xlim(0, view_size)
            self.canvas.draw()

    def record_serial_data(self):
        try:
            with serial.Serial(self.combobox.get(), 2000000, timeout=1) as ser:
                while self.recording:
                    if not self.paused and ser.in_waiting >= 2:
                        # if ser.read(2) != b'\xFF\xFF': continue
                        lsb = ser.read(1)
                        msb = ser.read(1)

                        if lsb and msb:
                            val = (msb[0] << 8) | lsb[0]
                            if 0 <= val <= 4095:
                                self.buf.append(val)
        except Exception as e:
            self.status_label.config(text=f"Error: {e}")
            self.start_button.config(state=tk.NORMAL)
            self.pause_button.config(state=tk.DISABLED)
            self.save_button.config(state=tk.DISABLED)
            self.recording = False

    def save_data(self):
        if not self.buf:
            messagebox.showinfo("No Data", "No samples recorded yet.")
            return

        elapsed = time.time() - self.start_time
        actual_sample_rate = int(len(self.buf) / (elapsed + 1e-5))
        self.sample_rate = actual_sample_rate
        print(f"[INFO] Using dynamic sample rate: {self.sample_rate} Hz")

        arr = np.array(self.buf, dtype=np.uint16)
        normalized = (arr - 2048) / 2048.0
        pcm = (normalized * 32767).astype(np.int16)

        with wave.open("output.wav", "wb") as wf:
            wf.setnchannels(1)
            wf.setsampwidth(2)
            wf.setframerate(self.sample_rate)
            wf.writeframes(pcm.tobytes())

        with open("output.csv", "w", newline='') as f:
            writer = csv.writer(f)
            writer.writerow(["Sample Index", "Value"])
            for i, val in enumerate(self.buf):
                writer.writerow([i, val])

        self.status_label.config(text=f"Saved output.wav & output.csv ({len(self.buf)} samples)")

if __name__ == "__main__":
    root = tk.Tk()
    app = SerialRecorderGUI(root)
    root.mainloop()
