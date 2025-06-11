# SoC 期末報告: 自訂 I²S 讀取麥克風數值

## 專案簡介

本專案旨在透過 Zynq-7000 SoC 架構，使用 Programmable Logic (PL) 內部自訂 I²S 接收器（I2S RX IP）讀取麥克風數值，並經過濾波處理後，透過 AXI DMA 傳送至 Processing System (PS) 端，再由 Linux kernel 中撰寫的 driver 將資料讀出至應用層。此系統可應用於即時音訊處理或語音辨識等嵌入式應用。

---

## 系統構成與流程

1. 麥克風以 I²S 協定傳送音訊資料
2. PL 中的 I2S RX IP 接收資料並輸出 AXI Stream 資料
3. 音訊資料進入濾波 IP 進行即時濾波處理
4. 經 AXI DMA 傳送至 PS 端記憶體
5. Linux kernel space 驅動讀取 DMA 緩衝資料
6. 使用者空間程式從 `/dev` 介面讀取最終音訊值

---

## 功能規格

* 支援立體聲 I²S 音訊資料接收
* 音訊資料經過 FIR 濾波器處理（可自訂參數）
* 使用 AXI DMA 以高效率將資料傳至記憶體
* 音訊格式：16-bit PCM，支援單通道或雙通道
* 更新頻率：48kHz 樣本速率（可調）

---

## 硬體介面規格

* I²S 信號輸入：`BCLK`, `LRCLK`, `SDATA`
* PL 實作：I2S RX IP、濾波器 IP、AXI DMA
* PS 控制介面：AXI-Lite（DMA 控制）、AXI-MM（資料存取）
* 可視化與除錯：使用 Vitis 與 Linux dmesg/logs

---

## 限制與考量

* 音訊來源與時脈（BCLK、LRCLK）須同步一致
* 濾波器延遲需考量（FIR 阻塞性）
* DMA buffer 管理需精確避免 overflow 或 underrun
* Linux driver 撰寫需支援非同步與中斷處理

---

## 驗收準則

* 驅動載入後產生 `/dev/i2s_audio` 節點
* dmesg 中可見驅動註冊成功
* 可透過測試程式讀取音訊資料並顯示 sample 值
* 音訊資料連續穩定無遺漏
* 測試不同頻率、濾波器參數仍能穩定運作

---

## Breakdown

![image](SoC_breakdown.png)

---

## API

1. I2S RX IP（自訂或 Xilinx IP）
| 項目   | 說明                                               |
| ---- | ------------------------------------------------ |
| 類型   | AXI-Stream                                       |
| 輸出介面 | `m_axis_tdata`, `m_axis_tvalid`, `m_axis_tready` |
| 功能   | 將接收到的 I²S 音訊轉為 AXI Stream 格式                     |
| 控制介面 | 若有 AXI-Lite，可支援啟動、reset、設定位元寬、sample rate 等參數    |
| 注意事項 | 若自訂 IP，須正確解析 LRCLK、BCLK 邊緣對應資料框架                 |


---

## 執行示例

```bash
# 查看裝置節點
ls /dev/i2s_audio

# 執行使用者程式
./read_audio
