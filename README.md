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

## IP 介面與 API 說明

### 1. I2S RX IP（自訂或 Xilinx IP）

| 項目       | 說明                                                                 |
|------------|----------------------------------------------------------------------|
| 類型       | AXI-Stream                                                           |
| 輸出介面   | `m_axis_tdata`, `m_axis_tvalid`, `m_axis_tready`                    |
| 功能       | 將接收到的 I²S 音訊資料轉換為 AXI Stream 數據流格式                  |
| 控制介面   | 可選 AXI-Lite，支援設定：啟動、重置、位元寬、採樣率等               |
| 注意事項   | 若為自訂 IP，需正確解析 LRCLK、BCLK 邊緣與資料對齊                 |

---

### 2. 濾波器 IP（FIR 或自訂）

| 項目       | 說明                                                                 |
|------------|----------------------------------------------------------------------|
| 類型       | AXI-Stream                                                           |
| 輸入介面   | `s_axis_tdata`, `s_axis_tvalid`, `s_axis_tready`                    |
| 輸出介面   | `m_axis_tdata`, `m_axis_tvalid`, `m_axis_tready`                    |
| 功能       | 對音訊數據進行 FIR 濾波處理（如低通、高通、帶通等）                |
| 參數控制   | 濾波 Tap 數與係數可由 AXI-Lite 或 Block RAM 設定                   |
| 注意事項   | 必須維持 AXI Stream 資料連續性，避免 tvalid/tready 不一致丟樣     |

---

### 3. AXI DMA（AXI-Stream to Memory-Mapped）

| 項目           | 說明                                                              |
|----------------|-------------------------------------------------------------------|
| 類型           | AXI DMA（Stream to Memory-Mapped）                               |
| 資料輸入       | `s_axis_s2mm`（從濾波器輸入 AXI Stream 音訊）                    |
| 控制介面       | AXI-Lite 控制暫存器（啟動、長度、來源位址等）                    |
| 資料寫入       | AXI-MM 寫入 PS DDR 或 OCM 記憶體                                  |
| 關鍵暫存器     | `DMA_CR`（控制）、`DMA_SR`（狀態）、`SA`（起始位址）、`Length`   |
| Linux API      | `dma_request_channel()`、`dmaengine_prep_slave_single()`、`dma_async_issue_pending()` |
| 中斷           | 支援傳輸完成中斷，可配合 Linux 中斷處理                          |

---

### 4. Linux Driver（Platform Driver）

| 項目         | 說明                                                              |
|--------------|-------------------------------------------------------------------|
| 類型         | Platform Driver                                                   |
| 設定方式     | 以 Device Tree 描述 DMA 與相關 IP 之記憶體位址                    |
| 核心 API     | `probe()`, `remove()`, `read()`, `open()`, `release()` 等函式     |
| DMA 控制     | 使用 DMAengine 框架，搭配中斷與工作佇列（workqueue）處理傳輸完成 |
| 裝置節點     | `/dev/i2s_audio`                                                  |
| 使用者 API   | 使用 `open()`、`read()`、`poll()` 或 `mmap()` 讀取 DMA buffer     |
| 除錯方式     | `dmesg`、`cat /proc/interrupts`、`debugfs`                         |

---

## 執行示例

```bash
# 查看裝置節點
ls /dev/i2s_audio

# 執行使用者程式
./read_audio
