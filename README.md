# SoC 期末報告: 使用 PS 內建 SPI IP 結合 Linux Driver 讀取濕度感測器數值

## 專案簡介

本專案目的是利用 Zynq SoC 中 Processing System (PS) 內建的 SPI IP 來與 Arduino 進行 SPI 通訊，以 Linux 的 driver 與 C 程式讀取 Arduino 來自濕度感測器的資料。


## 系統構成與流程

1. Arduino 濕度感測器，設定成 SPI Slave 
2. Zynq 的 SPI Master 通過 SPI 對接 Arduino
3. Linux 啟用 spidev 的 driver 與設計 C 程式操控SPI的讀取或寫入
4. 通過 `/dev/SPI_device.c` 讀取傳進來的濕度資料

## 依照規格

### 功能規格

* GPIO 或 AXI SPI 等方式實現 SPI Master
* SPI Mode 0（CPOL=0, CPHA=0）
* 資料格式：2 bytes (`uint16_t`) 代表濕度
* 更新頻率：每秒百次以上 (Arduino 速度決定)

### 硬體介面規格

* SPI 最大頻率：1MHz (可調整)
* 接腳：Zynq PS/PL SPI0 或 SPI1 (MISO/MOSI/SCLK/SS)

### 限制與考量

* Arduino 的 SPI Slave 回應有可能延遲，需要緩衝或手動 delay

## 驗收準則

* Linux driver 能成功註冊並出現在 `/dev`
* dmesg 日誌可看到 driver 載入資訊
* 可用 `cat` 或測試程式讀取濕度資料
* 同步於 Arduino 返回值，可繼續讀取不錯誤
* 具備基本除錯能力與穩定性

## 執行示例

```bash
# 檢查 driver 是否載入
dmesg | grep spidev

# 查看 device node
ls /dev/spidev*

# 執行測試程式
./SPI_device.c
```
## Break down

![image](SoC_breakdown.png)

## 未來改進方向

* 嘗試使用 PL SPI + DMA 以提升效能與擴充性
