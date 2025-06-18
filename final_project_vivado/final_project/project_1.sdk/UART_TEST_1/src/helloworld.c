#include "xparameters.h"
#include "xuartlite.h"
#include "xil_printf.h"
#include "xuartlite_l.h"
#include <stdio.h>
#include <stdlib.h>
#include "xuartps.h"

// 修改成你實際的 UART instance ID
#define UART_ARDUINO_DEVICE_ID XPAR_UARTLITE_0_DEVICE_ID

XUartLite UartArduino;

int main() {
    XUartLite_Initialize(&UartArduino, UART_ARDUINO_DEVICE_ID);

    xil_printf("=== Dual UART Receiver ===\r\n");
    xil_printf("UART1 for Arduino 16-bit binary stream\r\n");

    int running = 1;

    while (running) {
        // === UART0: 檢查是否有從 PC 收到命令 ===

        // === UART1: 接收來自 Arduino 的 16-bit 資料 ===
        if (XUartLite_IsReceiveEmpty(UartArduino.RegBaseAddress) == 0) {
            uint8_t lsb = XUartLite_RecvByte(UartArduino.RegBaseAddress);
            while (XUartLite_IsReceiveEmpty(UartArduino.RegBaseAddress));  // 等待下一個 byte
            uint8_t msb = XUartLite_RecvByte(UartArduino.RegBaseAddress);

            uint16_t raw = ((uint16_t)msb << 8) | lsb;
            uint16_t value = raw & 0x0FFF;  // 取 12-bit 有效資料;

            xil_printf("Arduino Data: %d (0x%04X)\r\n", value, value);
        }
    }

    return 0;
}
